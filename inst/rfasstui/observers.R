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
      outputVariables <<- input$graphVar
      if (length(outputVariables) < 4) cleanPlots()
      print(paste0('in set capabilities: ', outputVariables))
      # loadGraph()
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
      if (length(outputVariables) < 1) cleanMap()
      # loadMap()
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



#' Load custom project
#'
#' Observer function responsible for loading the custom project file when the user creates a custom project scenario
#' @return
#' @export
loadCustomProject <- function() {
  print("in load custom")


  if (is.null(input$input_custom_gcam_project) | (is.na(input$input_custom_gcam_project) | is.null(input$input_custom_gcam_project) | (input$input_custom_gcam_project == "")))
  {
    shinyalert::shinyalert("Missing Information", "Please name the scenario and load an emissions file before attempting to load the scenario.", type = "warning")
    return(NULL)
  }

  customPrj <- input$input_custom_gcam_project
  print(customPrj)

  tryCatch(
    {
      # Load scenario and custom emissions
      withProgress(message = paste('Loading Custom Project ', customPrj$name, "...\n"), value = 1/2,
         {
          prj <- rgcam::loadProject(customPrj$datapath)
          incProgress(1/1, detail = paste("Load complete."))
          Sys.sleep(0.2)
         })

      # Check required queries appear
      withProgress(message = paste('Checking Custom Project ', customPrj$name, "...\n"), value = 1/2,
         {
            prj.queries <- rgcam::listQueries(prj)
            req.queries <- c("ag production by crop type",
                             "ag production by subsector (land use region)",
                             "prices of all markets",
                             "Ag Commodity Prices",
                             "International Aviation emissions",
                             "International Shipping emissions",
                             "nonCO2 emissions by resource production",
                             "nonCO2 emissions by sector (excluding resource production)")

            if (!all(req.queries %in% prj.queries)) {
              shinyalert::shinyalert("Custom Project Error",print(paste('Error: the custom project does not contain the required queries')), type = "error")
              return(NULL)
            }
           incProgress(1/1, detail = paste("Check complete."))
           Sys.sleep(0.2)
         })
      return(prj)
    },
    warning = function(war)
    {
      showModal(modalDialog(
        title = "Warning",
        paste("Details:  ",war
        )
      ))
    },
    error = function(err)
    {
      shinyalert::shinyalert("Custom Project Error",print(paste('Error attempting to load custom project: ',err)), type = "error")
    })

}
