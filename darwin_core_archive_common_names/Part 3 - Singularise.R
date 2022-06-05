rm(list=ls())
cat("\014")

easypackages::packages("pluralize")

species_list <- readRDS("saved_objects/species_list.rds")

species_list$common.name <- pblapply(species_list$common.name, singularize)

saveRDS(species_list, "saved_objects/singularised_common_names.rds")
