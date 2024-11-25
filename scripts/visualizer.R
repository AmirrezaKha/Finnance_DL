# Function to compute descriptive statistics for a multilabel dataset
compute_multilabel_stats <- function(data, output_file = NULL) {
    cat("\n--- Dataset Statistics ---\n")
    
    # Number of rows and features
    num_rows <- nrow(data)
    num_features <- ncol(data)
    cat("Number of rows:", num_rows, "\n")
    cat("Number of features (columns):", num_features, "\n")
    
    # Calculate unique values for each column
    column_unique_values <- sapply(data, function(col) length(unique(col)))
    unique_values_df <- data.frame(
        Column = names(column_unique_values),
        UniqueValues = column_unique_values
    )
    cat("\n--- Unique Values Per Column ---\n")
    print(unique_values_df)
    
    # Treat "Sentiment" and "Type" as label columns
    label_columns <- c("Sentiment", "Type")
    label_columns <- intersect(label_columns, names(data))  # Ensure these columns exist in the dataset
    num_labels <- length(label_columns)
    cat("\nNumber of label columns:", num_labels, "\n")
    
    if (num_labels > 0) {
        # Unique classes per label
        label_stats <- column_unique_values[label_columns]
        min_classes <- min(label_stats)
        max_classes <- max(label_stats)
        avg_classes <- mean(label_stats)
        cat("\nLabel Column Stats:\n")
        cat("  Min classes per label:", min_classes, "\n")
        cat("  Max classes per label:", max_classes, "\n")
        cat("  Average classes per label:", round(avg_classes, 2), "\n")
        
        # Labels per instance
        labels_per_instance <- rowSums(data[label_columns] != 0)
        min_labels <- min(labels_per_instance)
        max_labels <- max(labels_per_instance)
        avg_labels <- mean(labels_per_instance)
        cat("\nLabels Per Instance Stats:\n")
        cat("  Min labels per instance:", min_labels, "\n")
        cat("  Max labels per instance:", max_labels, "\n")
        cat("  Average labels per instance:", round(avg_labels, 2), "\n")
    } else {
        # If no label columns are detected, provide default outputs
        cat("\nNo label columns detected. Skipping label-specific statistics.\n")
        min_classes <- NA
        max_classes <- NA
        avg_classes <- NA
        min_labels <- NA
        max_labels <- NA
        avg_labels <- NA
    }
    
    # Collect all stats in a table
    stats <- data.frame(
        Metric = c("Number of rows", "Number of features", "Number of label columns",
                   "Min classes per label", "Max classes per label", "Average classes per label",
                   "Min labels per instance", "Max labels per instance", "Average labels per instance"),
        Value = c(num_rows, num_features, num_labels,
                  min_classes, max_classes, avg_classes,
                  min_labels, max_labels, avg_labels)
    )
    
    # Save statistics and unique value counts to CSV files if output_file is provided
    if (!is.null(output_file)) {
        write.csv(stats, file = paste0(output_file, "_stats.csv"), row.names = FALSE)
        write.csv(unique_values_df, file = paste0(output_file, "_unique_values.csv"), row.names = FALSE)
        cat("\nStatistics saved to", paste0(output_file, "_stats.csv"), "\n")
        cat("Unique value counts saved to", paste0(output_file, "_unique_values.csv"), "\n")
    }
    
    return(list(stats = stats, unique_values = unique_values_df))
}


# Function to visualize text data structure and descriptive statistics
visualize_text_data_structure <- function(data, title, output_file = "output/output") {
    cat("\nVisualizing text data structure for:", title, "\n")
    
    # Print structure of the dataset
    print(str(data))  
    
    # Print the first few rows to understand the data
    print(head(data))
    
    # Show number of samples
    cat("\nNumber of samples in", title, ":", nrow(data), "\n")
    
    # Ensure output directory exists
    output_dir <- dirname(output_file)
    if (!dir.exists(output_dir)) {
        dir.create(output_dir, recursive = TRUE)
    }
    
    # Compute and display descriptive statistics
    stats <- compute_multilabel_stats(data, output_file)
    
    return(stats)
}

# General function to visualize both datasets
visualize_datasets <- function(text_data_path) {
    # Load text data from CSV
    text_data <- read.csv(text_data_path)
    
    # Set the output file path to "output/" directory
    output_file <- file.path("output", "text_data")
    
    # Visualize text data structure
    visualize_text_data_structure(text_data, "Text Data", output_file)
}
