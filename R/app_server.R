#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr mutate
#' @noRd
app_server <- function(input, output, session) {
  ##cache l'onglet recette
  golem::invoke_js("hide", "a[data-value='nav-recette']")#par défaut caché

  # Your application server logic
  #Init reactive values
  r_global = reactiveValues(
    #Ces tables restent fixes mais sont transmisent à l'aide de r_global
    tab_recettes = read.csv2(system.file("csv/recettes.csv", package = "recettesCC")),
    tab_ingredients = read.csv2(system.file("csv/ingredients.csv", package = "recettesCC")),
    tab_instructions = read.csv2(system.file("csv/instructions.csv", package = "recettesCC")),

    #Identifiant de la recette passé à la page_recette
    id_recette = NULL
  )

  #serveurs des modules
  mod_page_recherche_server("page_recherche", r_global = r_global)
  mod_page_recette_server("page_recette", r_global = r_global)

  #Events
  ##Passe à la page "recettes" quand une nouvelle recette est sélectionnée et affiche l'onglet recette
  observeEvent(r_global$id_recette, {
    golem::invoke_js("show", "a[data-value='nav-recette']")#affiche l'onglet la première fois
    updateNavbarPage(inputId = "main_nav",
                     selected = "nav-recette")
  })

  #Destruction de la session
  onSessionEnded(function(){
    dbDisconnect(db_recettes)
  })
}
