#' page_recette UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_page_recette_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("recettes")

  )
}

#' page_recette Server Functions
#'
#' @noRd
mod_page_recette_server <- function(id, r_global = r_global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_page_recette_ui("page_recette")

## To be copied in the server
# mod_page_recette_server("page_recette")
