#' Load the example GCAM project
#' @title get_example_prj
#' @export
get_example_prj <- function() {
  prj <- rgcam::loadProject(file.path("www","input","example_prj","example_ssp.dat"))
  return(prj)
}



#' Upload the xml queries
#' @title get_queries
#' @export
get_queries <- function() {
  queries_rfasst <- xml2::read_xml(file.path("www","input","queries","queries_rfasst.xml"))
  queries_rfasst_nonCO2 <- xml2::read_xml(file.path("www","input","queries","queries_rfasst_nonCO2.xml"))

  queries <- list()
  queries[["queries_rfasst"]] <- queries_rfasst
  queries[["queries_rfasst_nonCO2"]] <- queries_rfasst_nonCO2

  return(queries)
}



#' Global vars for scale colors of SSP scenarios
#' @title get_globalSSPColorScales
#' @export
get_globalSSPColorScales <- function() {

  globalSSPColorScales <- vector()
  globalSSPColorScales <- c("GCAM_SSP1" = "#5DBFDE", "GCAM_SSP2" = "#5CB95C", "GCAM_SSP3" = "#FBAB33",
                         "GCAM_SSP4" ="#D7534E", "GCAM_SSP5" ="#9E49D1")

  return(globalSSPColorScales)
}



#' Global vars for scale colors of SSP scenarios
#' @title get_globalSSPColorScales
#' @export
get_globalCustomColorScales <- function() {

  globalCustomColorScales <- vector()
  globalCustomColorScales <- c("#5DBFDE","#5CB95C","#FBAB33","#D7534E","#9E49D1")

  return(globalCustomColorScales)
}


#' Create master list of variable lookups for "capabilities" (output variables for graphing)
#' @title get_globalCapabilities
#' @export
get_globalCapabilities <- function() {

  globalCapabilities <- list()

  # "Concentrations"
  globalCapabilities[['concentration_pm25']] <- 'concentration_pm25'
  attr(globalCapabilities[['concentration_pm25']], 'longName') <- "PM25 concentration"

  globalCapabilities[['concentration_o3']] <- 'concentration_o3'
  attr(globalCapabilities[['concentration_o3']], 'longName') <- "O3 concentration"

  # "Health impacts"
  globalCapabilities[['health_deaths_pm25']] <- 'health_deaths_pm25'
  attr(globalCapabilities[['health_deaths_pm25']], 'longName') <- "Premature deaths due to PM25"

  globalCapabilities[['health_deaths_o3']] <- 'health_deaths_o3'
  attr(globalCapabilities[['health_deaths_o3']], 'longName') <- "Premature deaths due to O3"

  globalCapabilities[['health_deaths_total']] <- 'health_deaths_total'
  attr(globalCapabilities[['health_deaths_total']], 'longName') <- "Total premature deaths"

  # # "Agricultural impacts" TODO
  # globalCapabilities[['agriculture']] <- c('Relative yield los', 'Production loss', 'Revenue loss')
  # attr(globalCapabilities[['agriculture']], 'longName') <- "Agricultural impacts"
  #
  # # "Economic impacts" TODO
  # globalCapabilities[['economy']] <- c('VSL')
  # attr(globalCapabilities[['economy']], 'longName') <- "Economic imipacts"


  return(globalCapabilities)
}
