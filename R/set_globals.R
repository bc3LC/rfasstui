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

  # "Emissions"
  globalCapabilities[['emissions_bc']] <- 'emissions_bc'
  attr(globalCapabilities[['emissions_bc']], 'longName') <- "BC emissions"

  globalCapabilities[['emissions_nh3']] <- 'emissions_nh3'
  attr(globalCapabilities[['emissions_nh3']], 'longName') <- "NH3 emissions"

  globalCapabilities[['emissions_nmvoc']] <- 'emissions_nmvoc'
  attr(globalCapabilities[['emissions_nmvoc']], 'longName') <- "NMVOC emissions"

  globalCapabilities[['emissions_nox']] <- 'emissions_nox'
  attr(globalCapabilities[['emissions_nox']], 'longName') <- "NOx emissions"

  globalCapabilities[['emissions_pom']] <- 'emissions_pom'
  attr(globalCapabilities[['emissions_pom']], 'longName') <- "POM emissions"

  globalCapabilities[['emissions_so2']] <- 'emissions_so2'
  attr(globalCapabilities[['emissions_so2']], 'longName') <- "SO2 emissions"

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

  # "Agricultural impacts"
  globalCapabilities[['agriculture_ryl_mi']] <- 'agriculture_ryl_mi'
  attr(globalCapabilities[['agriculture_ryl_mi']], 'longName') <- "Agriculture relative yield loss"

  globalCapabilities[['agriculture_prod_loss']] <- 'agriculture_prod_loss'
  attr(globalCapabilities[['agriculture_prod_loss']], 'longName') <- "Agriculture production loss"

  globalCapabilities[['agriculture_rev_loss']] <- 'agriculture_rev_loss'
  attr(globalCapabilities[['agriculture_rev_loss']], 'longName') <- "Agriculture revenue loss"

  # # "Economic impacts" TODO
  # globalCapabilities[['economy']] <- c('VSL')
  # attr(globalCapabilities[['economy']], 'longName') <- "Economic imipacts"


  return(globalCapabilities)
}
