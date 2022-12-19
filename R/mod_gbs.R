#' @noRd
#' @importFrom shiny NS tagList
mod_gbs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shinyMobile::f7TextArea(
      ns("textarea"),
      label = "テキスト",
      placeholder = "各行400字・30行まで解析できます"
    ),
    shinyMobile::f7Select(
      ns("tf"),
      label = "TFの計算方法",
      choices = c("tf", "tf2", "tf3")
    ),
    shinyMobile::f7Select(
      ns("idf"),
      label = "IDFの計算方法",
      choices = c("idf", "idf2", "idf3", "idf4")
    ),
    reactable::reactableOutput(ns("table")),
    shiny::div(
      shiny::p(
        "© 2022 Akiru Kato |",
        enurl("https://github.com/paithiov909/capsuletower", "GitHub repo")
      )
    )
  )
}

#' @noRd
#' @import promises
mod_gbs_server <- function(id, hd = 30L, sub = 400L) {
  moduleServer(id, function(input, output, session) {
    # ns <- session$ns
    ret <-
      shiny::reactive({
        if (input$textarea != "") {
          text <- stringi::stri_split_lines(input$textarea, omit_empty = TRUE) |>
            unlist() |>
            head(hd) |>
            stringi::stri_sub(to = sub)
          df <- tangela::kuromoji(text) # this function cannot be wrapped in future_promise.
          future_promise({
            tangela::prettify(
              df,
              into = tangela::get_dict_features("ipa"),
              col_select = c("POS1", "POS2")
            ) |>
            dplyr::group_by(.data$doc_id, .data$token, .data$POS1, .data$POS2) |>
            dplyr::count() |>
            dplyr::ungroup() |>
            audubon::bind_tf_idf2(tf = input$tf, idf = input$idf)
          })
        } else {
          future_promise({
            data.frame(message = "空のデータフレームです")
          })
        }
      })
    output$table <-
      reactable::renderReactable({
        ret() %...>%
        reactable::reactable(
          filterable = TRUE,
          searchable = TRUE,
          striped = TRUE,
          compact = TRUE
        )
      })
  })
}
