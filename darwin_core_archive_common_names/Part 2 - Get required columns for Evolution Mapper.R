rm(list=ls())
cat("\014")

easypackages::packages("tibble", "magrittr", "dplyr", "stringr", "pbapply")

sapply(list.files("R", full.names = TRUE), source)

taxons_with_vernacular <- readRDS("saved_objects/taxons_with_vernacular.rds")

tibble_blank_authorship <- taxons_with_vernacular[
  taxons_with_vernacular$`dwc:scientificNameAuthorship` == "",
] %>%
  select(c(
    "common.name" = "dwc:vernacularName",
    "scientific.name" = "dwc:scientificName",
    "image.lookup.text" = "dwc:scientificName"
  ))

tibble_with_authorship <- get_tibble_with_authorship()

species_list <- bind_rows(
  tibble_blank_authorship,
  tibble_with_authorship
) %>%
  mutate(across(.cols = everything(), trimws)) %>%
  mutate(across(.cols = everything(), str_to_sentence)) %>%
  distinct() %>%
  arrange(nchar(common.name))

write.csv(species_list, "col_species_list.csv")