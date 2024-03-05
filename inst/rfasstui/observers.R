#' # This file contains miscellaneous observers (all except for those from the parameters which are in the parameters.r file and those that produce output, in output.r)


#' Keeps a list of the selected output variables for graphs
#'
#' Observer function that responds to changes in user input from the capabilities drop down field in the scenario output tab
#' @return loaded list of output variables
#' @importFrom magrittr %>%
#' @export
setGraphCapabilities <- function()
{
  print('in set capabilities')
  tryCatch(
    {
      outputVariables <<- input$capabilities
      print(outputVariables)
      if (length(outputVariables) < 4) cleanPlots()
      loadGraph()
    },
    error = function(err)
    {
      # error handler picks up where error was generated
      shinyalert::shinyalert("Error!",print(paste('Output Error: ',err)), type = "error")
    })
}

#' Keeps a list of the selected output variables for the map
#'
#' Observer function that responds to changes in user input from the capabilities drop down field in the scenario output tab
#' @return loaded list of output variables
#' @importFrom magrittr %>%
#' @export
setMapCapabilities <- function()
{
  print('in set capabilities')
  tryCatch(
    {
      outputVariables <<- input$mapVar
      print(outputVariables)
      if (length(outputVariables) < 1) cleanMap()
      loadMap()
    },
    error = function(err)
    {
      # error handler picks up where error was generated
      shinyalert::shinyalert("Error!",print(paste('Output Error: ',err)), type = "error")
    })
}


#' Load the chosen standard SSP scenario and rerun output/clean functions
#'
#' Observer function that is activated on a change to the SSP Scenario checkboxes. Will load/unload the scenario into rfasst_scen list
#' @param sspName (Character) - String value for the SSP scenario in the format of "SSP-2"
#' @return
#' @importFrom magrittr %>%
#' @export
setSSP <- function(sspName)
{
  print("in set SSP")
  print(sspName)
  tryCatch(
    {
      # If scenario is checked then load it, otherwise unload it
      if(input[[paste("input_",stringr::str_replace(sspName,"-", "_"), sep = "")]])
      {
        withProgress(message = paste('Loading Scenario SSP ', sspName, "...\n"), value = 1/2,
                     {
                       rfasst_scen[[sspName]] <<- sspName
                       path <- 'www/input/example_prj/example_ssp.dat' #rfasstui::paste0('example_conc_ssp',sspName)
                       scenario <- paste0('GCAM_',stringr::str_replace(sspName,"-", ""))
                       rfasst_scen[[sspName]]$path <<- path
                       rfasst_scen[[sspName]]$scenario <<- scenario

                       incProgress(1/1, detail = paste("Load complete."))
                       Sys.sleep(0.2)
                     })
        print('end set SSP')
        print(rfasst_scen[[sspName]])
      }
      else
      {
        rfasst_scen[[sspName]] <<- NULL
      }

      if(length(rfasst_scen) == 0) cleanPlots()
    },
    error = function(err)
    {
      # error handler picks up where error was generated
      shinyalert::shinyalert("Error!",print(paste('Output Error: ',err)), type = "error")

    })
}
