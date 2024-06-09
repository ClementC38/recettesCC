#' clean_recettes
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#' @importFrom dplyr select
#'
#' @noRd
clean_recettes <- function(current_recettes){
  req(current_recettes)
  current_recettes <- current_recettes |>
    select("Recette" = nom_recette, "Préparation (min)" = durée)
  return(current_recettes)
}
