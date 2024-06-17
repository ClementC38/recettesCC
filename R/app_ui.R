#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom bslib bs_theme
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(theme = bslib::bs_theme(version = 4, preset = "lux"),
              navbarPage(title = "Recettes CC",
                         id = "main_nav",
                         tabPanel("Recherche", value = "nav-recherche",
                                  mod_page_recherche_ui("page_recherche")
                         ),
                         tabPanel(title = "Recette", value = "nav-recette",
                                  mod_page_recette_ui("page_recette")
                         )
              )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "recettesCC"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
