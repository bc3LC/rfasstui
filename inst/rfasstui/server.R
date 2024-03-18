# This file is the application controller
setwd("~/GitHub/rfasstui/inst/rfasstui")
options(shiny.maxRequestSize=30*1024^2)
library(rfasstui)
library(rfasst)

# Global vars for scale colors for SSP scenarios
#' @details \code{globalColorScales}: Scale colors for SSP scenarios
#' @rdname constants
#' @export
globalSSPColorScales <- get_globalSSPColorScales()

# Global vars for scale colors for Custom scenarios
#' @details \code{globalColorScales}: Scale colors for Custom scenarios
#' @rdname constants
#' @export
globalCustomColorScales <- get_globalCustomColorScales()

# Create master list of variable lookups for "capabilities" (output variables for graphing)
#' @details \code{globalCapabilities} Capability string (internal name lookup/mapping) for rfasst output variables, organized by group
#' @rdname constants
#' @export
globalCapabilities <- get_globalCapabilities()

# List of queries to create an rfasst prj
#' @details \code{globalQueries}: GCAM queries
#' @rdname constants
#' @export
globalQueries <- get_queries()

# Example GCAM project
#' @details \code{globalExamplePrj}: GCAM project with the SSPs
#' @rdname constants
#' @export
globalExamplePrj <- get_example_prj()


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
  source("output.R", local = TRUE)
  source("observers.R", local = TRUE)

  #----- Set up non global variables in top level application scope

  ggplot2::theme_set(ggplot2::theme_minimal())
  rfasst_scen <- list() # list of selected scenarios
  outputVariables <- list() # list of the selected variables to be plotted in the Graph tab
  graphs_list <- list() # list of plots
  last_map <- list()
  scen_tab <- NULL # name of the scenarios active tab
  fig_tab <- NULL # name of the figures active tab
  loaded_prj <- NULL # last uploaded custom project (itself)

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

  # Check active figures' tab
  active_fig_tab <- reactive({
    if (input$nav == "Explore rfasst") {
      if (grepl("Scenario Output", input$nav.explore_rfasst)) return("Scenario Output")
      if (grepl("World Maps", input$nav.explore_rfasst)) return("World Maps")
      return(NULL)
    } else {
      return(NULL)
    }
  })
  observeEvent(active_fig_tab(), {
    if (!is.null(active_fig_tab())) {
      if (active_fig_tab() == "Scenario Output") fig_tab <<- "scenario.output"
      if (active_fig_tab() == "World Maps") fig_tab <<- "world.maps"
    } else fig_tab <<- NULL
  })


  # Check active scenarios' tab
  active_scen_tab <- reactive({
    if (input$nav == "Explore rfasst") {
      if (grepl("Standard Scenarios", input$nav.scenarios_rfasst)) return("Standard Scenarios")
      else if (grepl("Custom Scenarios", input$nav.scenarios_rfasst)) return("Custom Scenarios")
      return(NULL)
    } else {
      return(NULL)
    }
  })
  observeEvent(active_scen_tab(), {
    if (!is.null(active_scen_tab())) {
      if (active_scen_tab() == "Standard Scenarios") scen_tab <<- "standard.scenarios"
      else if (active_scen_tab() == "Custom Scenarios") scen_tab <<- "custom.scenarios"
    } else scen_tab <<- NULL
  })


  observeEvent(input$launch_explorer, updateTabsetPanel(session, "nav", selected = "Explore rfasst"), ignoreInit = TRUE)
  observeEvent(input$input_SSP_1, setSSP("SSP-1"), ignoreInit = TRUE)
  observeEvent(input$input_SSP_2, setSSP("SSP-2"), ignoreInit = FALSE)
  observeEvent(input$input_SSP_3, setSSP("SSP-3"), ignoreInit = TRUE)
  observeEvent(input$input_SSP_4, setSSP("SSP-4"), ignoreInit = TRUE)
  observeEvent(input$input_SSP_5, setSSP("SSP-5"), ignoreInit = TRUE)
  observeEvent(input$input_load_gcam_project, loadCustomProject(), ignoreInit = TRUE)
  observeEvent(input$graphVar, setGraphCapabilities(), ignoreInit = FALSE)
  observeEvent(input$loadGraphs, loadGraph(), ignoreInit = TRUE)
  observeEvent(input$loadMaps, {setMapCapabilities(); loadMap()}, ignoreInit = TRUE)
  # observeEvent(input$maps_year, loadMap(), ignoreInit = TRUE)

  #----- End observer function setup



  #----- Custom Functions

  # Function to download the queries file
  output$downloadQueries <- downloadHandler(
    filename = function() {
      paste("rfasst_queries", "zip", sep=".")
    },
    content = function(fname) {
      fs <- c()
      tmpdir <- tempdir()
      setwd(tempdir())

      xml_string <- as.character(globalQueries$queries_rfasst)
      writeLines(xml_string, 'queries_rfasst.xml')
      fs <- c(fs, 'queries_rfasst.xml')

      xml_string <- as.character(globalQueries$queries_rfasst_nonCO2)
      writeLines(xml_string, 'queries_rfasst_nonCO2.xml')
      fs <- c(fs, 'queries_rfasst_nonCO2.xml')

      zip::zip(zipfile=fname, files=fs)
    },
    contentType = "application/zip"
  )

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
