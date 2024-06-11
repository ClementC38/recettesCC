#' DT_add_checkbox
#'
#' @description Ajoute des checkbox (sans effets) dans la colonne la plus à gauche d'un DT
#'
#' @return The return value, if any, from executing the function.
#' @importFrom DT datatable
#'
#' @noRd
DT_add_checkbox <- function(tab, inputId){
  if(!(any(class(tab) %in% c("data.frame", "tibble")))){
    stop("tab doit \u00eatre un tibble ou data.frame")
  }

  #Une checkbox par ligne avec un id de type "inputId"_check_"numeroligne"
  vec_checkbox <- sapply(seq_len(nrow(tab)), function(i){
    HTML(text = paste0('<input type = \"checkbox\" id=\"', inputId, "_check_", i, '\">'))
  })

  tab_checked = cbind("Fait" = vec_checkbox,
                      tab)
  return(tab_checked)

}
