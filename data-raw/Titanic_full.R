# loading the needed libraries
library(datasets)
library(tibble)
library(dplyr)
library(purrr)

# looking at the table
dplyr::glimpse(Titanic)

# converting to tibble
tibble::as_tibble(Titanic)

# converting data frame to full length based on count information
Titanic_full <-
  tibble::as_tibble(datasets::Titanic) %>%
  tibble::rowid_to_column(var = "id") %>%
  dplyr::mutate_at(
    .vars = dplyr::vars("id"),
    .funs = ~ as.factor(.)
  ) %>%
  split(f = .$id) %>%
  purrr::map_dfr(.f = ~ tidyr::uncount(.x, n)) %>%
  dplyr::mutate_at(
    .vars = dplyr::vars("id"),
    .funs = ~ as.numeric(as.character(.))
  ) %>%
  dplyr::mutate_if(
    .predicate = is.character,
    .funs = ~ as.factor(.)
  ) %>%
  dplyr::mutate_if(
    .predicate = is.factor,
    .funs = ~ droplevels(.)
  ) %>%
  dplyr::select(-n, -id) %>%
  tibble::rownames_to_column(var = "id") %>%
  dplyr::mutate_at(
    .vars = "id",
    .funs = ~ as.numeric(as.character(.))
  )

# reordering the Class variables
Titanic_full$Class <-
  factor(
    x = Titanic_full$Class,
    levels = c("1st", "2nd", "3rd", "Crew", ordered = TRUE)
  )

# looking at the final dataset
dplyr::glimpse(Titanic_full)

# saving the files
readr::write_csv(x = Titanic_full, file = "data-raw/Titanic_full.csv")
save(Titanic_full, file = "data/Titanic_full.rdata")
