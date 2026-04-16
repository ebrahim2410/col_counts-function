#col_counts function

col_counts <- function(main_folder, ID_index, count_index) {
  #check
  if (!dir.exists(main_folder)) {
    stop("The specified main_folder does not exist.")
  }
  
  sample_folders <- list.dirs(main_folder, full.names = TRUE, recursive = FALSE)
  
  if (length(sample_folders) == 0) {
    stop("No sample folders found inside main_folder.")
  }
  
  #loop for sample
  
  list_of_abundance <- list()
  
  for (sample_folder in sample_folders) {
    
    sample_name <- basename(sample_folder)
    
    #co tsv
    
    tsv_files <- list.files(sample_folder, pattern = "\\.tsv$", full.names = TRUE)
    if (length(tsv_files) == 0) next
    
    tsv_file <- tsv_files[1]
    
    abundance <- read.delim(tsv_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
    
    #check for col
    
    if (ncol(abundance) < max(ID_index, count_index) || ID_index < 1 || count_index < 1) {
      stop(sprintf("Column indices are invalid for sample '%s': file has %d columns, requested ID_index=%d, count_index=%d",
                   sample_name, ncol(abundance), ID_index, count_index))
    }
    
    #co col and rename
    
    abundance_extracted <- abundance[, c(ID_index, count_index), drop = FALSE]
    colnames(abundance_extracted) <- c("target_id", sample_name)
    
    list_of_abundance[[sample_name]] <- abundance_extracted
  }
  
  #check
  
  if (length(list_of_abundance) == 0) {
    stop("No valid .tsv files were found in sample folders.")
  }
  
  merged_df <- Reduce(function(x, y) merge(x, y, by = "target_id", all = TRUE), list_of_abundance)
  merged_df <- merged_df[order(merged_df$target_id), , drop = FALSE]
  
  return(merged_df)
}