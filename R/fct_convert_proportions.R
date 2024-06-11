#' convert_proportions
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
convert_proportions <- function(tab, base_nb_personnes, new_nb_personnes){
  if(base_nb_personnes == new_nb_personnes) return(tab)

  ratio = new_nb_personnes/base_nb_personnes
  tab$quantite <- round(tab$quantite*ratio, 1)
  return(tab)
}
