#' filtre_recettes
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @importFrom dplyr filter pull
#' @noRd
#'
filtre_recettes <- function(tab_recettes, tab_ingredients,
                            texte_recherche, ingredient_must,
                            ingredient_cannot, type_recette){

  if(!is.null(texte_recherche)){
    tab_recettes <- tab_recettes |>
      filter(grepl(texte_recherche, nom_recette, ignore.case = TRUE))
  }

  if(!is.null(ingredient_must)){
    list_id_ok_must <- sapply(ingredient_must, function(x){
      tab_ingredients |>#check chaque ingrédient
      filter(nom_ingredient %in% x) |>
      pull(id_recette)
    }) |>
      Reduce(f = intersect, x = _)#intersect de toutes les recettes ayant un ingrédient

    tab_recettes <- tab_recettes |>
      filter(id_recette %in% list_id_ok_must)
  }

  if(!is.null(ingredient_cannot)){
    list_id_ok_cannot <- tab_ingredients |>
        filter(nom_ingredient %in% ingredient_cannot) |>
        pull(id_recette)

    tab_recettes <- tab_recettes |>
      filter(!id_recette %in% list_id_ok_cannot)
  }

  if(!is.null(type_recette)){
    tab_recettes <- tab_recettes |>
      filter(type %in% type_recette)
  }

  return(tab_recettes)
}
