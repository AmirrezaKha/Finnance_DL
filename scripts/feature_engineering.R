# Load necessary libraries
library(text2vec)
library(tidyverse)
library(dplyr)
library(data.table)
library(text)
library(tidytext)

# Define the feature engineering function
feature_engineering <- function(text_file_path, embedding_path) {
  cat("Loading data from the provided text file...\n")
  data <- read.csv(text_file_path, stringsAsFactors = FALSE)
  
  if (!"Description" %in% colnames(data)) {
    stop("Error: 'Description' column is not found in the input file. Please provide a valid input file.")
  }
  
  cat("Extracting and preprocessing the 'Description' column...\n")
  text_data <- data$Description

  # Tokenization and preprocessing
  cat("Tokenizing and cleaning text data...\n")
  tokenize <- function(text) {
    tolower(text) %>%
      gsub("[^a-z\\s]", "", .) %>%
      strsplit("\\s+") %>%
      unlist()
  }
  tokens <- lapply(text_data, tokenize)
  
  # Create an 'itoken' object from the list of tokens
  itoken_object <- itoken(tokens, progressbar = TRUE)
  
  cat("Creating vocabulary and Term-Document Matrix (TDM)...\n")
  vocab <- create_vocabulary(itoken_object)
  vectorizer <- vocab_vectorizer(vocab)
  tdm <- create_dtm(itoken_object, vectorizer)
  
  # Feature 1: Word embeddings (e.g., GloVe)
  cat("Loading pre-trained word embeddings...\n")
  embeddings <- fread(embedding_path, header = FALSE, data.table = FALSE, quote = "")
  word_vectors <- as.matrix(embeddings[, -1])
  rownames(word_vectors) <- embeddings[, 1]
  
  cat("Calculating sentence embeddings by averaging word vectors...\n")
  sentence_embeddings <- t(apply(as.matrix(tdm), 1, function(row) {
    words <- colnames(tdm)[row > 0]
    valid_words <- words[words %in% rownames(word_vectors)]
    
    if (length(valid_words) > 0) {
      valid_vectors <- word_vectors[valid_words, , drop = FALSE]
      colMeans(valid_vectors)
    } else {
      rep(0, ncol(word_vectors))
    }
  }))
  
  cat("Adding sentence embeddings to the data...\n")
  embedding_cols <- paste0("embedding_", seq_len(ncol(sentence_embeddings)))
  data <- cbind(data, setNames(as.data.frame(sentence_embeddings), embedding_cols))
  
  # Feature 2: Text length
  cat("Calculating text length feature...\n")
  data$text_length <- nchar(text_data)
  
  # Feature 3: Word count
  cat("Calculating word count feature...\n")
  data$word_count <- sapply(tokens, function(t) length(unlist(t)))
  
  # Feature 4: Average word length
  cat("Calculating average word length feature...\n")
  data$avg_word_length <- sapply(tokens, function(t) mean(nchar(unlist(t))))
  
  # Feature 5: Sentiment analysis score (simple polarity-based)
  cat("Calculating sentiment analysis scores using tidytext...\n")
  sentiment_lexicon <- tidytext::get_sentiments("bing")
  data$sentiment_score <- sapply(text_data, function(desc) {
    words <- unlist(strsplit(tolower(desc), "\\s+"))
    sentiment <- merge(data.frame(word = words), sentiment_lexicon, by = "word", all.x = TRUE)
    sum(sentiment$sentiment == "positive", na.rm = TRUE) - sum(sentiment$sentiment == "negative", na.rm = TRUE)
  })
  
  # Feature 6: TF-IDF scores
  cat("Calculating TF-IDF scores using tidytext...\n")
  tidy_data <- data %>%
    mutate(row_id = row_number()) %>%
    unnest_tokens(word, Description) %>%
    count(row_id, word, sort = TRUE)

  tfidf_data <- tidy_data %>%
    bind_tf_idf(word, row_id, n)

  tfidf_sums <- tfidf_data %>%
    group_by(row_id) %>%
    summarize(tfidf_sum = sum(tf_idf, na.rm = TRUE))

  data <- data %>%
    mutate(tfidf_sum = tfidf_sums$tfidf_sum[row_number()])
  
  # Feature 7: Unique word ratio
  cat("Calculating unique word ratio feature...\n")
  unique_words_count <- sapply(tokens, function(t) length(unique(unlist(t))))
  data$unique_word_ratio <- unique_words_count / data$word_count
  
  cat("Feature engineering complete. Returning the processed dataset.\n")
  return(data)
}
