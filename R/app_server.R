#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom RSQLite dbConnect dbReadTable dbDisconnect
#' @importFrom dplyr mutate
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  # Ouverture DB + décharge les bases dans des data.frames
  db_recettes = dbConnect(drv = RSQLite::SQLite(),
                          system.file("bdd/bdd_recette.sqlite", package = "recettesCC"))

  tab_recettes = dbReadTable(db_recettes, "recettes")
  tab_ingredients = dbReadTable(db_recettes, "ingredients") |>
    mutate(quantite = as.numeric(as.character(quantite)))
  tab_instructions = dbReadTable(db_recettes, "instructions")

  #Init reactive values
  r_global = reactiveValues(
    #Ces tables restent fixes mais sont transmisent à l'aide de r_global
    tab_recettes = tab_recettes,
    tab_ingredients = tab_ingredients,
    tab_instructions = tab_instructions,

    #Identifiant de la recette passé à la page_recette
    id_recette = NULL
  )

  #serveurs des modules
  mod_page_recherche_server("page_recherche", r_global = r_global)
  mod_page_recette_server("page_recette", r_global = r_global)

  #Events
  ##Passe à la page "recettes" quand une nouvelle recette est sélectionnée
  observeEvent(r_global$id_recette, {
    updateNavbarPage(inputId="main_nav",
                     selected="Recette")
  })

  ##cache l'onglet recette et l'affiche la première fois que id_recette est modofié
  golem::invoke_js("hideid", "page-recette")#par défaut caché
  observeEvent(r_global$id_recette, {
    golem::invoke_js("showid", "page-recette")
  })

  #Destruction de la session
  onSessionEnded(function(){
    dbDisconnect(db_recettes)
  })
}
