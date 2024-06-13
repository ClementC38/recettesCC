#' convert_proportions
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
convert_proportions <- function(tab, old_nb_personnes, new_nb_personnes){
  if(old_nb_personnes == new_nb_personnes) return(tab)

  ratio = new_nb_personnes/old_nb_personnes
  tab$quantite <- round(tab$quantite*ratio, 1)
  return(tab)
}
