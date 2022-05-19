get_scientific_names_for_remaining_blanks <- function(row) {
  str_remove(row[["image.lookup.text"]], row[["authorship"]])
}
