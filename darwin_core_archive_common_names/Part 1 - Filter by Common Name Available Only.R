rm(list=ls())
cat("\014")

easypackages::packages("finch", "magrittr", "dplyr", "stringr", "tibble", "pbapply")

col_dwca <- dwca_read("/home/jarrod/Downloads/338c4979-5f56-4c15-9121-600709088be9.zip", read = TRUE)

all_col_data <- col_dwca$data
rm(col_dwca)

taxons <- all_col_data$Taxon.tsv %>%
  select(c("dwc:taxonID", "dwc:taxonRank", "dwc:genericName", "dwc:infragenericEpithet", "dwc:specificEpithet",
           "dwc:infraspecificEpithet", "dwc:cultivarEpithet", "dwc:taxonRemarks"))
vernacular_names <- all_col_data$VernacularName.tsv %>%
  filter(`dcterms:language` == "eng") %>%
  select(-c(`dcterms:language`))
rm(all_col_data)

taxons_with_vernacular <- left_join(taxons, vernacular_names, by = c("dwc:taxonID" = "dwc:taxonID")) %>%
  dplyr::filter(!is.na(.$`dwc:vernacularName`)) %>%
  distinct(.)

rm(taxons)
rm(vernacular_names)

saveRDS(taxons_with_vernacular, "saved_objects/taxons_with_vernacular.rds")
