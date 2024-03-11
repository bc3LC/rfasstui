# This file handles anything output related (screen, file, etc)


#' Internal function used to clean up visual elements when the number of graph output variables changes
#'
#' @return Function does not return a value
cleanPlots <- function()
{
  print("in clean plots")

  # Clean all plots if there's no active rfasst scenario
  if(length(rfasst_scen) < 1)
  {
    output[["plot1"]] <<- NULL
    output[["plot2"]] <<- NULL
    output[["plot3"]] <<- NULL
    output[["plot4"]] <<- NULL
  }
  else
  {
    # Start in reverse and clear out (make NULL) any plots that exceed the number of output variables
    if(length(outputVariables) < 4)
      output[["plot4"]] <<- NULL
    if(length(outputVariables) < 3)
      output[["plot3"]] <<- NULL
    if(length(outputVariables) < 2)
      output[["plot2"]] <<- NULL
    if(length(outputVariables) < 1)
      output[["plot1"]] <<- NULL
  }
}


#' Internal function used to clean up visual elements when the number of map output variables changes
#'
#' @return Function does not return a value
cleanMap <- function()
{
  print("in clean map")

  output[["maps"]] <<- NULL
}


#' Output function that generates and displays the graphs
#'
#' Observer function designed to handle the loading/creation of the output graphs
#' @return no return value
#' @importFrom magrittr %>%
#' @export
loadGraph <- function()
{
  print("in load graph")

  # Main loop that handles graph output based on number of scenarios and number of output variables
  if(length(rfasst_scen) > 0)
  {
    # If length is 5 or more than they've chosen too many variables
    if(length(outputVariables) < 5)
    {
      tryCatch(
        {
          if(length(rfasst_scen) >= 1)
          {
            withProgress(message = 'Loading Output Graphs...\n', value = 0,
             {

               # This UI output variable is responsible for generating the 4 graphs in the output section.
               output$plots <- renderUI(
                 {
                   plot_output_list <- lapply(1:length(outputVariables), function(i)
                   {
                     plotname <- paste("plot", i, sep="")

                     tagList(
                       plotOutput(plotname, height = 500, width = '100%'),
                       downloadButton(paste0("download_graph", i), label = "Download graph"),
                       downloadButton(paste0("download_data", i), label = "Download data")
                     )
                   })

                   # Convert the list to a tagList - this is necessary for the list of items to display properly.
                   do.call(tagList, plot_output_list)
                 })


               # Create a new graph for each output variable
               for (i in 1:length(outputVariables))
               {
                 # Need local so that each item gets its own number. Without it, the value of i in the renderPlot() will be the same across all instances.
                 local(
                   {
                     my_i <- i
                     plotname <- paste("plot", my_i, sep="")

                     # Set up local variables for dealing with output data frames
                     df_total <- data.frame()

                     # Display all the considered scenarios
                     for (j in 1:length(rfasst_scen))
                     {
                       df_scenario <- computeOutput(rfasst_scen[j], outputVariables[[i]])
                       df_total <- rbind(df_total, df_scenario)
                     }

                     # Get the units for graph axis
                     x <- dplyr::distinct(df_total, units)
                     ggplotGraph <- ggplot2::ggplot(data=df_total, ggplot2::aes(x=year, y=value, group=scenario, color=scenario)) +
                       ggplot2::geom_line() +
                       ggplot2::labs(y=x[[1]], title = attr(globalCapabilities[[outputVariables[[i]]]], 'longName')) +
                       ggplot2::scale_color_manual(values = globalColorScales)

                     # Save the dataset and plot to a global list, graphs_list
                     graphs_list[[i]] <- outputVariables[[i]]
                     graphs_list[[i]]$graph <- get('ggplotGraph')
                     graphs_list[[i]]$data <- get('df_total')
                     assign("graphs_list", value = graphs_list, envir = .GlobalEnv)

                     # Construct the plots and add to the shiny output variable
                     output[[plotname]] <- renderPlot({
                       get('ggplotGraph')
                     })

                     # Display download graph button
                     output[[paste0("download_graph", my_i)]] <- downloadHandler(
                       filename = function() {
                         paste0("rfasst_", graphs_list[[my_i]], ".png")
                       },
                       content = function(file) {
                         # save plot
                         ggplot2::ggsave(file,
                                         plot = graphs_list[[my_i]]$graph, device = "png",
                                         dpi = 150, limitsize = TRUE, width = 15, height = 10
                         )
                       }
                     )

                     # Display download data button
                     output[[paste0("download_data", my_i)]] <- downloadHandler(
                       filename = function() {
                         paste0("rfasst_", graphs_list[[my_i]], ".csv")
                       },
                       content = function(file) {
                         # save data
                         write.csv(file = file,
                                   x = graphs_list[[my_i]]$data,
                                   row.names = F
                         )
                       }
                     )

                   })
                 incProgress(1/length(rfasst_scen), detail = paste(names(names(rfasst_scen)[i]), " loaded."))
                 Sys.sleep(0.25)
               }
             })
          }
          else
          {
            shinyalert::shinyalert("Invalid Input:", "Please choose at least one output variables.", type = "warning")
          }

        },
        error = function(err)
        {
          # error handler picks up where error was generated
          shinyalert::shinyalert("Error Detected:",print(paste('There was an error when attempting to load the graph:',err)), type = "error")
        })
    }
    else
    {
      shinyalert::shinyalert("Invalid Input:", "Please choose no more than four output variables.", type = "warning")
    }
  }
  else
  {
    shinyalert::shinyalert("No active scnearios", "Please set at least one of the SSP scenarios to active or upload a custom emissions scenario.", type = "warning")
  }
}



#' Main output function that generates the downscaled maps
#'
#' Observer function designed to handle the loading/creation of downscaled world maps from the rfasst model output
#' @return no return value
#' @export
loadMap <- function()
{
  print('in load map')

  tryCatch(
    {
      # First check for selected scenarios and variables
      all_ok = TRUE
      if(length(rfasst_scen) < 1)
      {
        all_ok = FALSE
        shinyalert::shinyalert("No active scenarios", "Please set at one of the SSP scenarios to active or upload a custom emissions scenario.", type = "warning")
      }
      else if(length(rfasst_scen) > 1)
      {
        all_ok = FALSE
        shinyalert::shinyalert("Choose only one scenario to display the map", "Please set at one of the SSP scenarios to active or upload a custom emissions scenario.", type = "warning")
      }

      if (all_ok)
      {
        # This UI output variable is responsible for generating the 4 graphs in the output section.
        output$maps <- renderUI(
          {
            maps_output_list <- lapply(1:1, function(i)
            {
              mapname <- paste("map", i, sep="")

              tagList(
                plotOutput(mapname, height = 500, width = '100%')
              )
            })

            # Convert the list to a tagList - this is necessary for the list of items to display properly.
            do.call(tagList, maps_output_list)
          })

        # Need local so that each item gets its own number. Without it, the value of i in the renderPlot() will be the same across all instances.
        local(
          {
            withProgress(message = 'Generating Map Data...\n', value = 0,
                         {
                           # Choose pattern file based on user choice of temperature or precipitation
                           user_year <- input$maps_year
                           map_year <- ifelse(user_year == 2000, 2005, user_year)

                           # Compute dataset to be plotted. Skip the computation if it was the last one performed (and only the year has changed)
                           if (length(last_map) > 0 && last_map[[1]] == paste0(rfasst_scen[1],'_',outputVariables[[1]])) {
                             df_total = last_map[[1]]$data
                           } else {
                             df_total <- computeOutput(rfasst_scen[1], outputVariables[[1]], regional = TRUE)
                             last_map[[1]] <<- paste0(rfasst_scen[1],'_',outputVariables[[1]])
                             last_map[[1]]$data <<- df_total
                           }

                           # Subset data to the user desired year. Since rfasst returns data from 2005, 2010, 2020, 2030 ... 2100,
                           # only these years are accepted, and if the user chose 2000, we print 2005 instead
                           incProgress(1/2, detail = paste("Loading Map...\n"))
                           mapFigure <- computeMap(df_total%>%
                                                     dplyr::filter(year == map_year),
                                                   outputVariables[[1]],
                                                   paste0(attr(globalCapabilities[[outputVariables[[1]]]], 'longName'), ', ', user_year))

                           # Construct the map and add to the shiny output variable
                           output[[mapname]] <- renderPlot({
                             get('mapFigure')
                           })

                           output$downloadMap <- downloadHandler(
                             filename = function() {
                               paste0("rfasst_map_", outputVariables[[1]], ".png")
                             },
                             content = function(file) {
                               # save plot
                               ggplot2::ggsave(file,
                                               plot = mapFigure, device = "png",
                                               dpi = 150, limitsize = TRUE, width = 15, height = 10
                               )
                             }
                           )

                           incProgress(1/1, detail = "Map loaded.")
                           # Sys.sleep(0.25)
                         })
          })
      }
    },

    error = function(err)
    {
      # error handler picks up where error was generated
      shinyalert::shinyalert("Error Detected:",print(paste('There was an error when attempting to load the graph:',err)), type = "error")
    })
}
