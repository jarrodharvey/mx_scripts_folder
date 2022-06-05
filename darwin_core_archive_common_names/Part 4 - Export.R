species_list <- readRDS("saved_objects/singularised_common_names.rds")

species_list$common.name <- unlist(species_list$common.name)

write.csv(species_list, "col_species_list.csv")
