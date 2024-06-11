#' clean_recettes
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#' @importFrom dplyr select
#' @importFrom DT formatStyle
#'
#' @noRd
clean_recettes <- function(current_recettes){
  req(current_recettes)
  current_recettes <- current_recettes |>
    select("Recette" = nom_recette, "Pr\u00e9paration (min)" = duree) |>
    DT_theme(theme = "minimal") |>
    DT::formatStyle(table = _, columns = c(1,2), cursor='pointer')

  return(current_recettes)
}
