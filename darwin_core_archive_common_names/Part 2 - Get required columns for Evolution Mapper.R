rm(list=ls())
cat("\014")

easypackages::packages()

taxons_with_vernacular <- readRDS("saved_objects/taxons_with_vernacular.rds")
