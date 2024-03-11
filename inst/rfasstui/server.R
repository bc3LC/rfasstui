# This file is the application controller
#
# library(rfasstui)
# library(rfasst)

# Global vars for scale colors
#' @details \code{globalColorScales}: Scale colors
#' @rdname constants
#' @export
globalColorScales <- get_globalColorScales()

# Create master list of variable lookups for "capabilities" (output variables for graphing)
#' @details \code{globalCapabilities} Capability string (internal name lookup/mapping) for rfasst output variables, organized by group
#' @rdname constants
#' @export
globalCapabilities <- get_globalCapabilities()


#' Main server/data processing function
#'
#' The server function is the main function that processes inputs and handles data i/o.
#' This is required for Shiny apps using the separate UI/Server file architecture.
#'
#' @param input - Creates the Shiny input object
#' @param output - Creates the Shiny output object
#' @param session - Creates the Shiny session object
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
server <- function(input, output, session)
{
  # Needed to interact Shiny with client side JS
  shinyjs::useShinyjs()

  # Load other source files
  source("parameters.R", local = TRUE)
  source("core.R", local = TRUE)
  source("output.R", local = TRUE)
  source("observers.R", local = TRUE)

  #----- Set up non global variables in top level application scope

  ggplot2::theme_set(ggplot2::theme_minimal())
  rfasst_scen <- list() # list of selected scenarios
  outputVariables <- list() #list of the selected variables to be plotted in the Graph tab
  graphs_list <- list() # list of plots
  last_map <- list()

  #----- End set up local vars



  #----- Set up graphs and maps

  # Set initial plotting variables
  for(i in 1:4)
  {
    plotname <- paste("plot", i, sep="")
    shinyjs::hide(plotname)
  }

  # Set initial mapping variables and hide
  for(i in 1:1)
  {
    mapname <- paste("map", i, sep="")
    shinyjs::hide(mapname)
  }

  #----- End set up plots and maps



  #----- Set up observer functions to catch user interaction on the input fields

  observeEvent(input$launch_explorer, updateTabsetPanel(session, "nav", selected = "Explore rfasst"), ignoreInit = TRUE)
  observeEvent(input$input_SSP_1, setSSP("SSP-1"), ignoreInit = TRUE)
  observeEvent(input$input_SSP_2, setSSP("SSP-2"), ignoreInit = FALSE)
  observeEvent(input$input_SSP_3, setSSP("SSP-3"), ignoreInit = TRUE)
  observeEvent(input$input_SSP_4, setSSP("SSP-4"), ignoreInit = TRUE)
  observeEvent(input$input_SSP_5, setSSP("SSP-5"), ignoreInit = TRUE)
  observeEvent(input$graphVar, setGraphCapabilities(), ignoreInit = TRUE)
  observeEvent(input$mapVar, setMapCapabilities(), ignoreInit = TRUE)
  observeEvent(input$loadGraphs, loadGraph(), ignoreInit = TRUE)
  observeEvent(input$loadMaps, loadMap(), ignoreInit = TRUE)
  observeEvent(input$maps_year, loadMap(), ignoreInit = )

  # Update graph and map variables when switching to these tabs
  active_tab <- reactive({
    if (input$nav == "Explore rfasst") {
      if (grepl("Scenario Output", input$nav.explore_rfasst)) return("Scenario Output")
      if (grepl("World Maps", input$nav.explore_rfasst)) return("World Maps")
      return(NULL)
    } else {
      return(NULL)
    }
  })
  observeEvent(active_tab(), {
    if (!is.null(active_tab())) {
      if (active_tab() == "Scenario Output") observeEvent(input$graphVar, setGraphCapabilities())
      if (active_tab() == "World Maps") observeEvent(input$mapVar, setMapCapabilities())
    }
  })

  #----- End observer function setup



  #----- Custom Functions

  # # Renders feedback form
  # output$feedbackFrame <- renderUI({
  #   frame_link <- tags$iframe(src="https://docs.google.com/forms/", # ADD google FORM
  #                             height=1100, width=700, seamless=NA)
  #   frame_link
  # })
  #
  # toggleCustom <- function()
  # {
  #   shinyjs::disable("input_enableCustom")
  # }

}

#----- End Custom Functions
