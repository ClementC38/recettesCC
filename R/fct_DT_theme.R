#' DT_theme
#'
#' @description Applique un theme custom à un DT
#'
#' @return The return value, if any, from executing the function.
#' @importFrom DT datatable
#'
#' @noRd
DT_theme <- function(tab, theme = "minimal"){
  if(theme[1] == "minimal"){
    tab_clean <- datatable(tab,
                           options = list(searching = FALSE, paging = FALSE, lengthChange = FALSE,
                                          pageLength = Inf, bInfo = FALSE, autoWidth = TRUE),
                           rownames = FALSE, escape = FALSE,
                           selection = "none")
  } else {tab_clean = tab}

  return(tab_clean)
}
