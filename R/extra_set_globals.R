#' #' Global vars for misc items such as the run date end year (2100)
#' #' @export
#' get_globalVars <- function() {
#'
#'   globalVars <- list()
#'   globalVars['startDate'] <- 1900
#'   globalVars['endDate'] <- 2100
#'   globalVars['writeDirectory'] <- "temp"
#'
#'   return(globalVars)
#' }
#'


#' Global vars for scale colors
#' @title get_globalColorScales
#' @export
get_globalColorScales <- function() {

  globalColorScales <- vector()
  globalColorScales <- c("GCAM_SSP1" = "#5DBFDE", "GCAM_SSP2" = "#5CB95C", "GCAM_SSP3" = "#FBAB33",
                         "GCAM_SSP4" ="#D7534E", "GCAM_SSP5" ="#9E49D1", "Reference" ="#9E49D1") # TODO delete Reference


  return(globalColorScales)
}
#'
#'
#' #' RCP list by number
#' #' @export
#' get_rcps <- function() {
#'
#'   return(c(26,45,60,85))
#' }
#'
#'
#' #' Global file paths vector
#' #' @export
#' get_globalScenarios <- function() {
#'
#'   rcps <- get_rcps()
#'
#'   globalScenarios <- list()
#'   globalScenarios[['RCP-2.6']] <-  file.path('input',paste0('hector_rcp',rcps[1],'.ini'))
#'   globalScenarios[['RCP-4.5']] <-  file.path('input',paste0('hector_rcp',rcps[2],'.ini'))
#'   globalScenarios[['RCP-6.0']] <-  file.path('input',paste0('hector_rcp',rcps[3],'.ini'))
#'   globalScenarios[['RCP-8.5']] <-  file.path('input',paste0('hector_rcp',rcps[4],'.ini'))
#'
#'   return(globalScenarios)
#' }
#'
#'
#' #' Global scenario color schemes
#' #' @export
#' get_globalScenarioColors <- function() {
#'
#'   return(c("RCP 2.6" = "#5DBFDE", "RCP 4.5" = "#5CB95C", "RCP 6.0" = "#FBAB33", "RCP 8.5" = "#D7534E"))
#' }
#'
#'
#' #' Global temperature patterns
#' #' @export
#' get_globalTempPatterns <- function() {
#'
#'   return(c("CanESM2" = "www/maps/tas_Amon_CanESM2_esmrcp85_r1i1p1_200601-210012_pattern.rds",
#'            "CESM1-BGC" = "www/maps/tas_Amon_CESM1-BGC_rcp85_r1i1p1_200601-210012_pattern.rds",
#'            "GFDL-ESM2G" = "www/maps/tas_Amon_GFDL-ESM2G_rcp85_r1i1p1_200601-210012_pattern.rds",
#'            "MIROC-ESM" = "www/maps/tas_Amon_MIROC-ESM_esmrcp85_r1i1p1_200601-210012_pattern.rds",
#'            "MPI-ESM-LR" = "www/maps/tas_Amon_MPI-ESM-LR_esmrcp85_r1i1p1_200601-210012_pattern.rds",
#'            "MRI-ESM1" = "www/maps/tas_Amon_MRI-ESM1_esmrcp85_r1i1p1_200601-210012_pattern.rds"))
#' }
#'
#'
#' #' Global precipitation patterns list
#' #' @export
#' get_globalPrecipPatterns <- function() {
#'
#'   return(c("CanESM2" = "www/maps/pr_Amon_CanESM2_rcp85_r1i1p1_200601-210012_pattern.rds",
#'            "CESM1-BGC" = "www/maps/pr_Amon_CESM1-BGC_rcp85_r1i1p1_200601-210012_pattern.rds",
#'            "GFDL-ESM2G" = "www/maps/pr_Amon_GFDL-ESM2G_rcp85_r1i1p1_200601-210012_pattern.rds",
#'            "MIROC-ESM" = "www/maps/pr_Amon_MIROC-ESM_rcp85_r1i1p1_200601-210012_pattern.rds",
#'            "MPI-ESM-LR" = "www/maps/pr_Amon_MPI-ESM-LR_rcp85_r1i1p1_200601-210012_pattern.rds",
#'            "MRI-ESM1" = "www/maps/pr_Amon_MRI-ESM1_rcp85_r1i1p1_200601-210012_pattern.rds"))
#' }
#'
#'
#' #' Create master list of parameter lookup strings
#' #' @export
#' get_globalParameters <- function() {
#'
#'   globalParameters <- vector()
#'   globalParameters['pco2'] <- hector::PREINDUSTRIAL_CO2()
#'   globalParameters['q10'] <- hector::Q10_RH() #2.0
#'   globalParameters['beta'] <- hector::BETA() #0.36
#'   globalParameters['ecs'] <- hector::ECS() #3.0
#'   globalParameters['aero'] <- hector::AERO_SCALE() #1.0
#'   globalParameters['volc'] <- hector::VOLCANIC_SCALE() #1.0
#'   globalParameters['diff'] <- hector::DIFFUSIVITY() #2.3
#'
#'   return(globalParameters)
#' }
#'
#'
#'
#' #' Default Hector parameters
#' #' @export
#' get_globalParamsDefault <- function() {
#'
#'   return(c('alpha' = 1, 'beta' = 0.36, 'diff' = 2.3, 'S' = 3, 'C' = 276.09, 'q10_rh' = 2, 'volscl' = 1))
#'
#' }
#'
#' #' CanESM2 Parameter Sets
#' #' @export
#' get_globalParamsCanESM2 <- function() {
#'
#'   return(c('alpha' = 1.87, 'beta' = 0.08, 'diff' = 0.98, 'S' = 3.88, 'C' = 282.35, 'q10_rh' = 1.75, 'volscl' = 1.81))
#'
#' }
#'
#'
#' #' CESM1-BGC Parameter Set
#' #' @export
#' get_globalParamsCESM1BGC <- function() {
#'
#'   return(c('alpha' = -0.43, 'beta' = 0.0, 'diff' = 8, 'S' = 2.4, 'C' = 280.31, 'q10_rh' = 1.78, 'volscl' = 3.94))
#'
#' }
#'
#'
#'
#' #' GFDL-ESM2G Parameter Set
#' #' @export
#' get_globalParamsGFDLESM2G <- function() {
#'
#'   return(c('alpha' = 0.46, 'beta' = 0.07, 'diff' = 12.01, 'S' = 2.03, 'C' = 289.24, 'q10_rh' = 1.76, 'volscl' = 2.12))
#'
#' }
#'
#'
#'
#' #' MIROC-ESM Parameter Set
#' #' @export
#' get_globalParamsMIROCESM <- function() {
#'
#'   return(c('alpha' = 1.05, 'beta' = 0.02, 'diff' = 6.39, 'S' = 5.83, 'C' = 283.31, 'q10_rh' = 1.77, 'volscl' = 2.02))
#'
#' }
#'
#'
#'
#' #' MPI-ESM-LR Parameter Set
#' #' @export
#' get_globalParamsMPIESMLR <- function() {
#'
#'   return(c('alpha' = 1.22, 'beta' = 0.28, 'diff' = 2.93, 'S' = 3.66, 'C' = 289.13, 'q10_rh' = 1.75, 'volscl' = 0.70))
#'
#' }
#'
#'
#'
#' #' MRI-ESM1 Parameter Set
#' #' @export
#' get_globalParamsMRIESM1 <- function() {
#'
#'   return(c('alpha' = 1.42, 'beta' = 0.66, 'diff' = 4.21, 'S' = 2.04, 'C' = 289.49, 'q10_rh' = 1.76, 'volscl' = 0.27))
#'
#' }

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

  # # "Agricultural impacts"
  # globalCapabilities[['agriculture']] <- c('Relative yield los', 'Production loss', 'Revenue loss')
  # attr(globalCapabilities[['agriculture']], 'longName') <- "Agricultural impacts"
  #
  # # "Economic impacts"
  # globalCapabilities[['economy']] <- c('VSL')
  # attr(globalCapabilities[['economy']], 'longName') <- "Economic imipacts"


  return(globalCapabilities)
}
