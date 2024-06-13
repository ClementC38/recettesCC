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
    div(id = "page-recette",
        htmlOutput(outputId = ns("nom_recette")),
        numericInput(inputId = ns("Nb_personnes"),
                     label = "Nombre de personnes",
                     value = NULL,
                     min = 0, step = 1),
        hr(),
        h4("Ingr\u00e9dients :"),
        fluidRow(DTOutput(outputId = ns("tab_ingredients"), width = "50%")),
        br(),
        h4("Etapes :"),
        fluidRow(DTOutput(outputId = ns("tab_instructions"), width = "80%")),
        br(),
        h4("Commentaire :"),
        htmlOutput(outputId = ns("texte_commentaire"))
    ))
}

#' page_recette Server Functions
#'
#' @importFrom dplyr select
#' @noRd
mod_page_recette_server <- function(id, r_global = r_global){
  moduleServer( id, function(input, output, session){

    ns <- session$ns

    r_local <- reactiveValues(
      current_recette = NULL,
      current_ingredients = NULL,
      current_instructions = NULL,
      prec_Nb_personnes = NULL
    )

    #Extraction des instructions et ingrédients sur update de l'id_recette
    observeEvent(eventExpr = r_global$id_recette, handlerExpr = {
      #r_local
      r_local$current_recette <- r_global$tab_recettes |>
        filter(id_recette %in% r_global$id_recette)

      r_local$current_ingredients <- r_global$tab_ingredients |>
        filter(id_recette %in% r_global$id_recette)

      r_local$current_instructions <- r_global$tab_instructions |>
        filter(id_recette %in% r_global$id_recette)

      #Sauvegarde le nombre de personnes de base pour calculer les doses selon le nb de personnes
      r_local$prec_Nb_personnes <- r_local$current_recette$Nb_personnes

      #UI
      updateNumericInput(inputId = "Nb_personnes", value = r_local$current_recette$Nb_personnes)
    })

    #Update des quantités d'ingrédients selon le nombre de personnes
    observeEvent(eventExpr = input$Nb_personnes, handlerExpr = {
      req(input$Nb_personnes)
      r_local$current_ingredients <- convert_proportions(tab = r_local$current_ingredients,
                                                         old_nb_personnes = r_local$prec_Nb_personnes,
                                                         new_nb_personnes = input$Nb_personnes)
      r_local$prec_Nb_personnes <- input$Nb_personnes#update du nb de personnes considéré dans current_recette
    })


    #Output
    output$nom_recette <- renderUI({
      req(r_global$id_recette)
      h2(r_local$current_recette$nom_recette)
    })

    output$tab_ingredients <- renderDT({
      req(r_global$id_recette)
      r_local$current_ingredients |>
        select("Ingr\u00e9dient" = nom_ingredient,
               "Quantit\u00e9" = quantite,
               "Unit\u00e9" = unite) |>
        DT_add_checkbox(inputId = "tab_ingredients") |>
        DT_theme(theme = "minimal")
    })

    output$tab_instructions <- renderDT({
      req(r_global$id_recette)
      r_local$current_instructions |>
        select(Etape = etape) |>
        DT_add_checkbox(inputId = "tab_instructions") |>
        DT_theme(theme = "minimal")
    })

    output$texte_commentaire <- renderUI({
      req(r_global$id_recette,
          r_local$current_recette$commentaire)
      p(r_local$current_recette$commentaire)
    })

  })
}

## To be copied in the UI
# mod_page_recette_ui("page_recette")

## To be copied in the server
# mod_page_recette_server("page_recette")
