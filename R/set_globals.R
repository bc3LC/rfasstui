#' Global vars for scale colors
#' @title get_globalColorScales
#' @export
get_globalColorScales <- function() {

  globalColorScales <- vector()
  globalColorScales <- c("GCAM_SSP1" = "#5DBFDE", "GCAM_SSP2" = "#5CB95C", "GCAM_SSP3" = "#FBAB33",
                         "GCAM_SSP4" ="#D7534E", "GCAM_SSP5" ="#9E49D1")


  return(globalColorScales)
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
