#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    shinyMobile::f7Page(
      title = "capsuletower",
      shinyMobile::f7SingleLayout(
        shinyMobile::f7Shadow(mod_gbs_ui("capsule"), intensity = 10),
        navbar = shinyMobile::f7Navbar(title = "capsuletower")
      ),
      options = list(dark = FALSE),
      allowPWA = FALSE
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
      app_title = "capsuletower"
    )
  )
}
