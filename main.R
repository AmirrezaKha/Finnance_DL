# main.R

# Source the pipeline script to run the main pipeline
source('scripts/pipeline.R')

# Run the pipeline without specifying paths; loading is handled within the pipeline
run_pipeline()
