# col_counts Function

## Overview

The `col_counts` function aggregates count data from multiple `.tsv` files organized in subdirectories. Each subdirectory represents a separate sample, and the function extracts selected columns from each file before merging them into a single unified data frame.

This is especially useful in data analysis workflows (e.g., bioinformatics, feature counting) where multiple samples need to be combined for downstream analysis.

---

## How It Works

* Scans a main directory for subfolders (samples).
* Treats each subfolder as an individual sample.
* From each sample:

  * Identifies the first `.tsv` file.
  * Extracts:

    * A target identifier column
    * A count column
  * Renames the count column using the sample (folder) name.
* Merges all samples into a single data frame using the target identifier.
* Sorts the final output by the identifier.

---

## Parameters

### `main_folder`

* **Type:** character
* **Description:** Path to the main directory containing sample subfolders.

**Requirements:**

* Must exist
* Must contain at least one subfolder

---

### `ID_index`

* **Type:** numeric
* **Description:** Column index corresponding to the target identifier.
* **Purpose:** Used as the key for merging across samples.

---

### `count_index`

* **Type:** numeric
* **Description:** Column index corresponding to the count values.
* **Purpose:** Extracted and renamed per sample.

---

## Expected Directory Structure

```
main_folder/
│
├── sample_1/
│   └── file.tsv
│
├── sample_2/
│   └── file.tsv
│
└── sample_3/
    └── file.tsv
```

* Each subfolder = one sample
* Each sample contains at least one `.tsv` file
* Only the first `.tsv` file per folder is used

---

## Output

The function returns a merged data frame:

* **Rows:** Unique target identifiers
* **Columns:** Samples
* **Values:** Counts per sample

Additional notes:

* Missing values are preserved (if a target is absent in a sample)
* Output is sorted by target identifier
* Column names correspond to sample (folder) names

---

## Error Handling

The function includes built-in validation:

* Stops if the main directory does not exist
* Stops if no sample folders are found
* Skips folders without `.tsv` files
* Stops if column indices are invalid
* Stops if no valid `.tsv` files are found

---

## Notes

* Only the first `.tsv` file in each sample folder is processed
* Data is merged using a full outer join
* Column names in the output correspond to sample (folder) names

---

## Use Cases

* Gene expression count aggregation
* Feature abundance tables
* Multi-sample data integration workflows

---

## Summary

The `col_counts` function is designed to efficiently combine count data from multiple samples stored in separate subdirectories. It automates reading the first `.tsv` file from each sample folder, extracting a specified identifier column and count column, and merging all samples into a single unified data frame. Each column in the final output represents a sample, while each row corresponds to a unique target identifier, making it ideal for downstream comparative and statistical analyses.
