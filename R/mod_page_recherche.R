#' page_recherche UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom DT DTOutput renderDT
mod_page_recherche_ui <- function(id){
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(width = 3,
                   h2("Chercher une recette"),
                   textInput(ns("texte_recherche"), "Rechercher :", NULL),
                   selectizeInput(
                     inputId = ns("ingredient_must"),
                     label = "Avec :",
                     choices = c("A", "B"),#list_ingredients,
                     selected = NULL,
                     multiple = TRUE,
                     width = "100%",
                     size = 2,
                     options = list(
                       'plugins' = list('remove_button'),
                       'create' = TRUE,
                       'persist' = TRUE
                     )),
                   selectizeInput(
                     inputId = ns("ingredient_cannot"),
                     label = "Sans :",
                     choices = c("A", "B"),#list_ingredients,
                     selected = NULL,
                     multiple = TRUE,
                     width = "100%",
                     size = 2,
                     options = list(
                       'plugins' = list('remove_button'),
                       'create' = TRUE,
                       'persist' = TRUE
                     )),
                   checkboxGroupInput(ns("type_recette"),
                                      label = "Type de plat :",
                                      choices = list("Entrée" = "Entrée", "Plat" = "Plat", "Dessert" = "Dessert"),
                                      selected = list("Entrée", "Plat", "Dessert")),
                   actionButton(ns("search_button"), label = "Rechercher"),
      ),

      # Show a plot of the generated distribution
      mainPanel(
        h3("Liste des recettes correspondant à la recherche :"),
        DTOutput(outputId = ns("listing_recettes"))
      )
    )
  )
}

#' page_recherche Server Functions
#'
#' @noRd
mod_page_recherche_server <- function(id, r_global = r_global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    #Update de l'UI selon les ingrédients présents dans la base

    #Init reactive values
    r_local <- reactiveValues(
      current_recettes = NULL
    )

    #Update lors de la recherche
    observeEvent(eventExpr = input$search_button, handlerExpr = {
      #Extraction des recettes recherchées
      r_local$current_recettes = filtre_recettes(tab_recettes = r_global$tab_recettes,
                                                 tab_ingredients = r_global$tab_ingredients,
                                                 texte_recherche = input$texte_recherche,
                                                 ingredient_must = input$ingredient_must,
                                                 ingredient_cannot = input$ingredient_cannot,
                                                 type_recette = input$type_recette)

    })

    #Outputs
    output$listing_recettes <- renderDT(expr = {
      clean_recettes(r_local$current_recettes)
    })

  })
}

## To be copied in the UI
# mod_page_recherche_ui("page_recherche")

## To be copied in the server
# mod_page_recherche_server("page_recherche")
