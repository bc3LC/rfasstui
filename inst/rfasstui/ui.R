#
# This is a Shiny web application UI document. It describes the on screen components that define the visual application.

library(shinyBS)
library(shinyWidgets)

# Using Shiny Fixed layout
fluidPage(theme = shinythemes::shinytheme("readable"),
          title = "rfasstUI: An Interactive Air Pollution Model",

          # Code that gets called on first load of application to load in any themes/css etc
          # Loads the custom.css file that contains custom styles and overwrites some built in styles
          tags$head
          (
            tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
          ),
          shinyjs::useShinyjs(),

          tags$div(class = "container",
                   tags$img(src = "images/sky.png", height = "500px", width = "150%", class = "earth", alt = "Earth's atmosphere"),
                   tags$div(
                     a(
                       img(src = "images/bc3_logo.png", class = "logo"), href = "https://www.bc3research.org/", target = "_blank"),
                     h1("rfasstUI", class = "header-text-title"),
                     h2("An Interactive Air Pollution Model", class = "header-text-sub", style = "font-weight:normal; "),
                   ),
          ),
          br(),
          # Main component from which all other components fall under, navbarPage, a multi-page user-interface that includes a navigation bar
          navbarPage
          (
            id = "nav",
            title = "",
            collapsible = TRUE,
            # Main navigation
            tabPanel(
              "Home",
              fluidRow(column(7, div(class = "home-text",
                                     p("Welcome to the user interface for",
                                       tags$b("rfasst:"),
                                       " an open source, Lorem ipsum dolor sit amet consectetur adipiscing, elit class lacus libero ridiculus,
                                       natoque torquent augue posuere nunc. Nostra iaculis metus scelerisque magna massa hac fusce, posuere
                                       hendrerit bibendum venenatis senectus habitant nec vestibulum, sociosqu montes auctor viverra cursus nullam.", style = "float:left"),
                                     p("This interactive version is built upon previous work including the development of the initial ",
                                       a("rfasst R Package", href="https://github.com/bc3LC/rfasst/", target="blank"), "."),
                                       style = "float: left"
              )),
              column(4, div(
                br(),
                br(),

                actionButton(inputId = "launch_explorer",
                             label = "Explore rfasst",
                             style = "background: #409948; color: white;
                                                             font-size: 24px; padding: 32px 24px;
                                                             box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);"),
                align = "center"
              ))
              )
            ),
            tabPanel(
              "Guides",
              # Main Panel that holds the tabs for the Information section
              mainPanel
              (
                width = 15,
                class = "about-info",
                tabsetPanel
                (
                  # Video Tab Panel
                  tabPanel
                  (
                    p(icon("youtube", "fa-1x"), "rfasst Tutorial", value="videoTab"),
                    style="vertical-align: middle;",
                    h4("Ready to get started?",
                      tags$a("View the Guide/Tutorial", href="", target="blank")), # TODO add link to youtube tutorial
                    tags$hr(class="hrNav"),
                    br(),
                    HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/fBHXS7pjZcI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                  ),

                  # Project creation pannel
                  tabPanel
                  (
                    p(icon("code", "fa-1x"), "rgcam Project Creation", value="prjCreationTab"),
                    h4("How to create an rgcam project suitable for rfasst"),
                    tags$hr(class="hrNav"),
                    br(),
                    h6('To generate an ',
                    a("rgcam", href="https://github.com/JGCRI/rgcam", target="blank"),
                    ' project suitable to run ',
                    a("rfasst", href="https://github.com/bc3LC/rfasst", target="blank"),
                    ' you can follow the instructions below:'),
                    br(),

                    tags$ol(
                      class = "h7",
                      tags$li("Run your ", a("GCAM", href="https://github.com/JGCRI/GCAM", target="blank"), " scenarios."),
                      tags$li("Dowload ", a("R", href="https://www.r-project.org", target="blank"), " and install rgcam ", verbatimTextOutput("console_code_rgcam"), "and rfasstui ", verbatimTextOutput("console_code_rfasstui")),
                      tags$li("Dowload ", a("this",
                                            href="https://github.com/bc3LC/rfasstui/raw/main/inst/rfasstui/www/input/queries.zip",
                                            download="queries.zip",
                                            target="_blank"), " folder and unzip it."),
                      tags$li("Run the following code indicating the database path and the queries files path:", verbatimTextOutput("console_code_prj"))
                    )
                  )

                )

              )
            ),
            # Main panel for the interactive section of the application
            tabPanel(
              "Explore rfasst",
              sidebarPanel(
                width = 4,
                tabsetPanel(
                  id = 'nav.scenarios_rfasst',
                  tabPanel(class = "params",
                           "Standard Scenarios",
                           h5("Share Socioeconomic Pathways"),

                           shinyWidgets::prettyCheckbox(inputId = "input_SSP_1", label = "SSP1", value = FALSE, width = 60,
                                                        inline = TRUE, icon = icon("check"), animation = "jelly", status = "success"),
                           shinyWidgets::prettyCheckbox(inputId = "input_SSP_2", label = "SSP2", value = TRUE, width = 60,
                                                        inline = TRUE, icon = icon("check"), animation = "jelly", status = "success"),
                           shinyWidgets::prettyCheckbox(inputId = "input_SSP_3", label = "SSP3", value = FALSE, width = 60,
                                                        inline = TRUE, icon = icon("check"), animation = "jelly", status = "success"),
                           shinyWidgets::prettyCheckbox(inputId = "input_SSP_4", label = "SSP4", value = FALSE, width = 60,
                                                        inline = TRUE, icon = icon("check"), animation = "jelly", status = "success"),
                           shinyWidgets::prettyCheckbox(inputId = "input_SSP_5", label = "SSP5", value = FALSE, width = 60,
                                                        inline = TRUE, icon = icon("check"), animation = "jelly", status = "success"),

                           # Add hover popups with parameter descriptions
                           bsPopover("input_SSP_1", "SSP1: Sustainability, taking the green road",
                                     placement = "top", trigger = "hover", options = NULL),
                           bsPopover("input_SSP_2", "SSP2: Middle of the road",
                                     placement = "top", trigger = "hover", options = NULL),
                           bsPopover("input_SSP_3", "SSP3: Regional rivalry, a rocky road",
                                     placement = "top", trigger = "hover", options = NULL),
                           bsPopover("input_SSP_4", "SSP4: Inequality, a road divided",
                                     placement = "top", trigger = "hover", options = NULL),
                           bsPopover("input_SSP_5", "SSP5: Fossil-fueled development, taking the highway",
                                     placement = "top", trigger = "hover", options = NULL),

                           chooseSliderSkin(skin = "Flat", color = "#327a38"),

                  ),
                  # Custom Scenarios Tab Panel
                  tabPanel
                  (class = "params",
                    "Custom Scenarios",
                    div
                    (
                      h5("Custom Emissions Pathway"),
                      tags$hr(class="hrNav"),
                      p("Steps to run your own scenario with custom emissions:"),
                      tags$ol(
                        tags$li("Download ", tags$a(href = "https://github.com/JGCRI/gcam-core", "GCAM")),
                        tags$li("Run your GCAM scenario/s"),
                        tags$li("Create your ", tags$a(href = "https://github.com/JGCRI/rgcam", "rgcam"), " project with the example queries below."),
                        tags$li(class = "no-number", "Detailed step-by-step here") # TODO: add link
                      ),
                      div(
                        downloadButton("downloadQueries", label = "Download queries file", icon = icon("download"))
                      ),
                      br(),
                      fluidRow(
                        column(
                          width = 8,
                          fileInput("input_custom_gcam_project", "Upload Custom GCAM project:", width = "100%",
                                    buttonLabel = "Choose Project", accept = c(".prj", ".dat", ".csv"))
                        ),
                        column(
                          width = 4,
                          actionButton(inputId = "input_load_gcam_project", label = "Load Project", width = "100%",
                                       style = "margin-top: 0.625cm;")
                        )
                      )
                    ) # End Div
                  ) # End Custom Scenarios Tab Panel
                )
              ),
              # Right hand content panel - Main panel that is used for output
              mainPanel
              (width = 8,
                tabsetPanel
                (id = 'nav.explore_rfasst',
                  # Graphs Tab
                  tabPanel
                  (fixed = TRUE,
                    p(icon("chart-line","fa-2x"), "Scenario Output", value="outputTab"),
                    br(),
                    p("Please note that output variables need to be computed and can take several seconds to load. Due to this, graphs will need to be refreshed manually after adding/removing any scenario."),
                    div(
                      tags$table
                      (
                        tags$tr
                        (class = "output-vars",
                          tags$td
                          (
                            selectInput
                            ("graphVar",  "Choose Output Variables:",
                              list('Pollutants concentration' = list("PM25"="concentration_pm25", "O3"="concentration_o3"),
                                   'Health impact' = list("Premature deaths due to PM25" = 'health_deaths_pm25', "Premature deaths due to O3" = 'health_deaths_o3', "Premature deaths Total" = 'health_deaths_total'),
                                   'Agricultural impact' = list("Relative yield loss"='agricultural_rel_yield_loss', "Production loss"='agricultural_prod_loss', "Revenue loss"='agricultural_rev_loss'), #TODO: consider Mi and AOT40 rel yield loss??
                                   'Economic impact' = list("VSL"='economic_vsl')),
                              multiple = T, selected = "health_deaths_total")
                          ),
                        )
                      ),
                      uiOutput("customScenarioSelector1"),
                      actionButton(inputId="loadGraphs", label="Load Graphs", width = '200px', style = "background: #409948; color: white;"),
                      br(),
                      br(),
                      uiOutput("plots", class = "customPlot")
                    )
                  ), # end Graphs Tab

                  # Maps tab
                  tabPanel
                  (class = "maps",
                    p(icon("globe-americas","fa-2x"), "World Maps", value="outputTab"),
                    br(),
                    p("Please note that output variables need to be computed and can take several seconds to load. Due to this, maps will need to be refreshed manually after adding/removing any scenario."),
                    fluidRow(
                      column(3, selectInput(inputId = "mapVar", label = "Choose Variable:", selected = "tas", width = "400px",
                                            choices = list('Pollutants concentration' = list("PM25"="concentration_pm25", "O3"="concentration_o3"),
                                                           'Health impact' = list("Premature deaths due to PM25" = 'health_deaths_pm25', "Premature deaths due to O3" = 'health_deaths_o3', "Premature deaths Total" = 'health_deaths_total'),
                                                           'Agricultural impact' = list("Relative yield loss"='agricultural_rel_yield_loss', "Production loss"='agricultural_prod_loss', "Revenue loss"='agricultural_rev_loss'), #TODO: consider Mi and AOT40 rel yield loss??
                                                           'Economic impact' = list("VSL"='economic_vsl')),
                                            multiple = F)
                      ),
                      column(9, sliderInput("maps_year", "Map year", min = 2000, max = 2100, value = 2020, step = 10, post = "", width = "90%")
                      )
                    ),
                    uiOutput("customScenarioSelector2"),
                    actionButton(inputId="loadMaps", label="Load Map", width = 150, style = "background: #0B3F8F; color: white;"),
                    downloadButton("downloadMap", label="Save Hi-Res Map", width = 150),
                    br(),
                    uiOutput("maps", class = "customPlot")
                  ) # End Maps Tab

                ) # End tabset panel
              ) # End mainpanel
            ),
            tabPanel
            (
              "About",
              # Main Panel that holds the tabs for the Information section
              mainPanel
              (
                width = 9,
                class = "about-info",
                tabsetPanel
                (
                  # Information Tab Panel
                  tabPanel
                  (
                    p(icon("info-circle", "fa-2x"), "rfasst Information", value="infoTab"),
                    h5("Background Information"), tags$hr(class="hrNav"),
                    tags$table(
                      tags$tr(
                        tags$td(width = "50%",
                                h5("Explore rfasst", style="text-align: left"),
                                br(),
                                h6("Source code and contribution is available on the ",
                                   a("rfasstUI Github page", href = "https://github.com/bc3LC/rfasstui/", target = "_blank")),
                        ),
                      )
                    ),
                    br(),
                    tags$td(
                      tags$figure(
                        img(src='https://github.com/bc3LC/rfasst/blob/main/vignettes/vignetteFigs/PM2.5_concentration_2050.png',
                            height="260px"),
                        tags$figcaption("rfasst's global PM25 concentrations for SSP XXX in 2050")
                      ), style="text-align: center"
                    ),
                    br(),

                    h5("Documentation/Downloads"),
                    tags$hr(class="hrNav"),
                    p("The primary link to the rfasst model documentation is the ",
                      a("online manual", href="https://jgcri.github.io/rfasst/index.html", target="blank"),
                      ", which is included in the vignettes/manual directory. The code is also documented with ",
                      a("Doxygen-style", href="http://doxygen.org", target="blank"),
                      " comments."),
                    p("A formal model description paper via ",
                      a("Sampedro et al. 2022", href="https://joss.theoj.org/papers/10.21105/joss.03820", target="blank")),
                    tags$ul(
                      tags$li(
                        h5(tags$a("rfasst User Interface package download/source link ", href="https://github.com/bc3LC/rfasstui", target="blank"))),
                      tags$li(
                        h5(tags$a("rfasst R package download/source link", href="https://github.com/bc3LC/rfasst", target="blank"))),
                      tags$li(
                        h5(tags$a("Code and data for rfasst", href="https://zenodo.org/records/7417835", target="blank"),
                           tags$img(src="https://zenodo.org/badge/DOI/10.5281/zenodo.344924589.svg", class="zenodo", alt="DOI")
                        )
                      )
                    ),
                    br(),
                    h5("Tools and software that work with rfasst"),
                    tags$hr(class="hrNav"),
                    tags$ul(
                      tags$li(
                        a("GCAM", href="https://github.com/JGCRI/gcam-core", target="blank"),
                        ": rfasst can be used as a post-processing tool of the GCAM integrated assessment model."),
                      tags$li(
                        a("rfasst", href="https://github.com/bc3LC/rfasst", target="blank"),
                        ": rfasst is an R package that can be easily installed."),
                      tags$li(
                        a("R/Shiny", href="https://shiny.rstudio.com/", target="blank"),
                        ": This application was built as an R-Shiny package wrapper over the existing model code.")
                    )
                  ),
                  # Citation Tab Panel
                  tabPanel
                  (
                    p(icon("copyright", "fa-2x"),
                      "License/How to Cite",
                      value="citeTab"),
                    h5("License Information"),
                    tags$hr(class="hrNav"),
                    tags$div(class="citationsDiv", style="width: 500px;",
                             tags$table(class="citationsTable",
                                        tags$tr(
                                          tags$td(rowspan=2, width=45, icon("balance-scale", "fa-2x")),
                                          tags$td(("All rfasst applications are licensed under the")
                                          ),
                                          tags$tr(
                                            tags$td(
                                              tags$a(
                                                h6("GNU General Public License v3.0"), target="blank")
                                            )
                                          )
                                        ),
                                        tags$table(class="citationsTable",
                                                   tags$tr(
                                                     tags$td(p("Permissions of this strong copyleft license are conditioned on making available complete source code
                                                               of licensed works and modifications, which include larger works using a licensed work, under the same
                                                               license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.")
                                                     )
                                                   )
                                        )
                             )
                    ),
                    div(class="citationsDiv",
                        tags$span(class="citationsHeader", "Permissions"),
                        tags$ul(class="ul-None",
                                tags$li(icon("check"),"Commercial use"),
                                tags$li(icon("check"),"Modification"),
                                tags$li(icon("check"),"Distribution"),
                                tags$li(icon("check"),"Patent use"),
                                tags$li(icon("check"),"Private use"))
                    ),
                    div(class="citationsDiv",
                        tags$span(class="citationsHeader", "Limitations"),
                        tags$ul(class="ul-None",
                                tags$li(icon("times")," Liability"),
                                tags$li(icon("times")," Warranty"))
                    ),
                    div(class="citationsDiv",
                        tags$span(class="citationsHeader", "Conditions"),
                        tags$ul(class="ul-None",
                                tags$li(icon("info"),"License and copyright notice"),
                                tags$li(icon("info"),"State changes"),
                                tags$li(icon("info"),"Disclose source"),
                                tags$li(icon("info"),"Same license"))
                    ),
                    h5("How to Cite rfasst"),
                    tags$hr(class="hrNav"),
                    p("When using graphs, figures, or other output from this applicaton please cite both the rfasst Core",
                      br(),
                      "application as well as the rfasst User Interface (this application). The DOI for both is provided below:"),
                    tags$ul(
                      tags$li(
                        h5(tags$a("rfasst Core DOI", href="https://doi.org/10.5281/zenodo.7417835", target = "blank"),
                           tags$img(src="https://zenodo.org/badge/DOI/10.5281/zenodo.7417835.svg", alt="DOI", class = "imgNoPadding"))),
                      tags$li(
                        h5(tags$a("rfasst User Interface DOI", href="https://doi.org/10.5281/zenodo.XXXXX", target = "blank"),
                           tags$img(src="https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXX.svg", alt="DOI", class = "imgNoPadding")))
                    )
                  ),
                  # Feedback Tab Panel
                  tabPanel
                  (
                    p(icon("comment", "fa-2x"), "Support", value="feedbackTab"),
                    h5("Submit Feedback"), tags$hr(class="hrNav"),
                    p("Please use the form below to contact the rfasst team regarding any questions, concerns, suggestions, or problems you may encounter."),
                    htmlOutput("feedbackFrame")
                  )
                )
              )
            ),
            tags$style(HTML(".navbar-nav {
                                float:none;
                                margin:0 auto;
                                display: block;
                                text-align: center;
                                color: #000000;
                            }

                            .navbar-nav > li {
                                display: inline-block;
                                float:none;
                                color: #000000;
                            }"))
          ), # End navbarpage
          hr(),
          p(em("Acknowledgments"),
            class = "sticky_footer", style = "font-size:12px;")
) # End of everything.
