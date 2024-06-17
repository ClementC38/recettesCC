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
      sidebarPanel(width = 4,
                   h2("Chercher une recette"),
                   textInput(ns("texte_recherche"), "Nom :", NULL) |>
                     tagAppendAttributes(#onkeydown => créer un input text_recherche_keydown qui prend la touche enfoncée
                       onkeydown = sprintf("Shiny.setInputValue('%s_keydown', event.key)", ns("texte_recherche"))),
                   selectizeInput(
                     inputId = ns("ingredient_must"),
                     label = "Avec :",
                     choices = NULL,#init à NULL
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
                     choices = NULL,#init à NULL
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
                                      choices = list("Entr\u00e9e" = "Entr\u00e9e", "Plat" = "Plat", "Dessert" = "Dessert"),
                                      selected = list("Entr\u00e9e", "Plat", "Dessert")),
                   actionButton(ns("search_button"), label = "Rechercher", width = "auto"),
                   actionButton(ns("recette_alea"), label = "Recette au hasard", width = "auto")
      ),

      # Show a plot of the generated distribution
      mainPanel(width = 8,
                h3("Liste des recettes correspondant \u00e0 la recherche :"),
                DTOutput(outputId = ns("listing_recettes"), width = "100%")
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
    observeEvent(eventExpr = r_global$tab_ingredients, handlerExpr = {
      updateSelectizeInput(session = session, inputId = "ingredient_must",
                           choices = unique(r_global$tab_ingredients$nom_ingredient))


      updateSelectizeInput(session = session, inputId = "ingredient_cannot",
                           choices = unique(r_global$tab_ingredients$nom_ingredient))
    })


    #Init reactive values
    r_local <- reactiveValues(
      current_recettes = NULL#tab des recettes recherchées
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

      showNotification(ui = "S\u00e9lection mise \u00e0 jour.", type = "message", duration = 1)
    })

    #Update de la recherche lorsque l'utilisateur appuis sur "entrer" dans textinput
    observeEvent(eventExpr = input$texte_recherche_keydown,  handlerExpr = {
      if(input$texte_recherche_keydown == "Enter"){
        golem::invoke_js("clickon", "#page_recherche-search_button")
      }
    })

    #Event clic tableau (update id_recette)
    observeEvent(input$listing_recettes_cell_clicked$value, {
      r_global$id_recette <- r_local$current_recettes[input$listing_recettes_cell_clicked$row,"id_recette"]
    })

    #Event recette aléatoire
    observeEvent(input$recette_alea, {
      r_global$id_recette <- sample(x = r_global$tab_recettes$id_recette, size = 1)
    })


    #Outputs
    ##tableau des recettes sélectionnées
    output$listing_recettes <- renderDT(expr = {
      req(r_local$current_recettes)
      clean_recettes(r_local$current_recettes)
    })
  })
}

## To be copied in the UI
# mod_page_recherche_ui("page_recherche")

## To be copied in the server
# mod_page_recherche_server("page_recherche")
