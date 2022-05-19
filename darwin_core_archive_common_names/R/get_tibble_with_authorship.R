get_tibble_with_authorship <- function() {
  non_blank_authorship <- taxons_with_vernacular[
    taxons_with_vernacular$`dwc:scientificNameAuthorship` != "",
  ]

  tibble_non_blank_authorship <- tibble(
    common.name = non_blank_authorship$`dwc:vernacularName`,
    scientific.name = paste(
      non_blank_authorship$"dwc:genericName",
      non_blank_authorship$"dwc:infragenericEpithet",
      non_blank_authorship$"dwc:specificEpithet",
      non_blank_authorship$"dwc:infraspecificEpithet"
    ) %>%
      str_replace_all(" {2,}", " "),
    image.lookup.text = non_blank_authorship$"dwc:scientificName",
    authorship = non_blank_authorship$`dwc:scientificNameAuthorship`
  )

  tibble_non_blank_authorship[
    tibble_non_blank_authorship$scientific.name == " ",
  ]$scientific.name <- pbapply(
    tibble_non_blank_authorship[
      tibble_non_blank_authorship$scientific.name == " ",
    ], 1, get_scientific_names_for_remaining_blanks
  )

  tibble_non_blank_authorship <- select(tibble_non_blank_authorship, -c("authorship"))

  return(tibble_non_blank_authorship)
}
