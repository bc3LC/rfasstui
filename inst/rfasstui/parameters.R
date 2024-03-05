library(magrittr)

# Compute the desired map given a dataset

#' Compute health, agricultural, or economic map
#'
#' @param map_data dataset from rfasst
#' @param variable desired output: concentration_pm25, concentration_o3,
#' health_deaths_pm25, health_deaths_o3, health_deaths_total,
#' agricultural_rel_yield_loss, TODO
#' economic_vsl TODO
#' @param map_title title of the map
#' @return dataset
#' @importFrom magrittr %>%
#' @export
computeMap <- function(map_data, variable, map_title) {

  print('in compute map')
  map_figure <- NULL

  if (variable == 'concentration_pm25') {
    print('in concentration_pm25')

    pm25.map <- map_data %>%
      dplyr::rename(subRegion=region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(units="ug/m3",
                    year=as.numeric(as.character(year)))

    save(pm25.map, file = 'pm25.map.RData')

    map_figure <- rmap::map(data = pm25.map,
                            shape = fasstSubset,
                            legendType = "pretty",
                            background  = T,
                            title = map_title)
  }
  else if (variable == 'concentration_o3') {
    print('in concentration_o3')

    o3.map <- map_data %>%
      dplyr::rename(subRegion=region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(units="ppbv",
                    year=as.numeric(as.character(year)))

    map_figure <- rmap::map(data = o3.map,
                  shape = fasstSubset,
                  legendType = "pretty",
                  background  = T,
                  save = F,
                  title = map_title)
  }
  else if (variable == 'health_deaths_pm25') {
    print('in health_deaths_pm25')

    pm.yll.fin.map <- map_data %>%
      dplyr::rename(subRegion = region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(year = as.numeric(as.character(year)),
                    units = "Premature deaths")

    map_figure <- rmap::map(data = pm.yll.fin.map,
                  shape = fasstSubset,
                  legendType = "pretty",
                  background  = T,
                  save = F,
                  title = map_title)
  }
  else if (variable == 'health_deaths_o3') {
    print('in health_deaths_o3')

    o3.mort.map <- map_data %>%
      dplyr::rename(subRegion = region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(year = as.numeric(as.character(year)),
                    units = "Premature deaths")

    map_figure <- rmap::map(data = o3.mort.map,
                  shape = fasstSubset,
                  legendType = "pretty",
                  background  = T,
                  save = F,
                  title = map_title)
  }
  else if (variable == 'health_deaths_total') {
    print('in health_deaths_total')

    tot.mort.map <- map_data %>%
      dplyr::rename(subRegion = region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(year = as.numeric(as.character(year)),
                    units = "Premature deaths")

    map_figure <- rmap::map(data = tot.mort.map,
                  shape = fasstSubset,
                  legendType = "pretty",
                  background  = T,
                  save = F,
                  title = map_title)

  }


  return(map_figure)
}




# Compute the desired output given a GCAM project

#' Compute health, agricultural, or economic output
#'
#' @param prj_data
#' @param variable desired output: concentration_pm25, concentration_o3,
#' health_deaths_pm25, health_deaths_o3, health_deaths_total,
#' agricultural_rel_yield_loss, TODO
#' economic_vsl TODO
#' @param regional TRUE if dataset grouped by region, FALSE if only the World region is considered
#' @return dataset
#' @importFrom magrittr %>%
#' @export
computeOutput <- function(prj_data, variable, regional = FALSE)
{
  print('in compute output')

  prj_name <- names(prj_data)
  prj_path <- prj_data[[prj_name]]$path
  prj_scenario <- prj_data[[prj_name]]$scenario
  prj <- rgcam::loadProject(prj_path)
  scen <- rgcam::listScenarios(prj)
  max_year <- 2050 # max(prj[[scen[1]]][['prices of all markets']]$year)
  # if scenarios where selected, (in the case of the SSP example prj), plot only this ones
  if (!is.null(prj_scenario)) scen <- prj_scenario

  if (variable == 'concentration_pm25') {
    print('in concentration_pm25')
    return_data <- lapply(scen, function(sc)
      rfasst::m2_get_conc_pm25(prj_name = prj_path,
                               final_db_year = max_year,
                               scen_name = sc,
                               saveOutput = F,
                               map = F, anim = F) %>%
        dplyr::mutate(scenario = sc) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = dplyr::if_else(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, units, scenario, region) %>%
        dplyr::summarise(value = median(value)) %>%
        dplyr::ungroup()
    )

    # Bind all the datasets together
    return_data <- dplyr::bind_rows(return_data)

    # If necessary, remove the region column
    if (!regional) {
      return_data <- return_data %>%
        dplyr::select(-region)
    }
  }
  else if (variable == 'concentration_o3') {
    print('in concentration_o3')
    return_data <- lapply(scen, function(sc)
      rfasst::m2_get_conc_o3(prj_name = prj_path,
                             final_db_year = max_year,
                             scen_name = sc,
                             saveOutput = F,
                             map = F, anim = F) %>%
        dplyr::mutate(scenario = sc) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, units, scenario, region) %>%
        dplyr::summarise(value = median(value)) %>%
        dplyr::ungroup())

    # Bind all the datasets together
    return_data <- dplyr::bind_rows(return_data)

    # If necessary, remove the region column
    if (!regional) {
      return_data <- return_data %>%
        dplyr::select(-region)
    }

  }
  else if (variable == 'health_deaths_pm25') {
    print('in health_deaths_pm25')
    return_data <- lapply(scen, function(sc)
      rfasst::m3_get_mort_pm25(prj_name = prj_path,
                               final_db_year = max_year,
                               scen_name = sc,
                               saveOutput = F,
                               map = F, anim = F) %>%
        dplyr::mutate(scenario = sc) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, scenario, region) %>%
        dplyr::summarise(value = sum(GBD)) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(units = 'Number of premature deaths'))

    # Bind all the datasets together
    return_data <- dplyr::bind_rows(return_data)

    # If necessary, remove the region column
    if (!regional) {
      return_data <- return_data %>%
        dplyr::select(-region)
    }
  }
  else if (variable == 'health_deaths_o3') {
    print('in health_deaths_o3')
    return_data <- lapply(scen, function(sc)
      rfasst::m3_get_mort_o3(prj_name = prj_path,
                             final_db_year = max_year,
                             scen_name = sc,
                             saveOutput = F,
                             map = F, anim = F) %>%
        dplyr::mutate(scenario = sc) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, scenario, region) %>%
        dplyr::summarise(value = sum(GBD2016)) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(units = 'Number of premature deaths'))

    # Bind all the datasets together
    return_data <- dplyr::bind_rows(return_data)

    # If necessary, remove the region column
    if (!regional) {
      return_data <- return_data %>%
        dplyr::select(-region)
    }
  }
  else if (variable == 'health_deaths_total') {
    print('in health_deaths_total')
    return_data <- lapply(scen, function(sc)
      dplyr::bind_rows(
        rfasst::m3_get_mort_pm25(prj_name = prj_path,
                                 final_db_year = max_year,
                                 scen_name = sc,
                                 saveOutput = F,
                                 map = F, anim = F) %>%
          dplyr::mutate(scenario = sc) %>%
          dplyr::rowwise() %>%
          dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
          dplyr::group_by(year, scenario, region) %>%
          dplyr::summarise(value = sum(GBD)) %>%
          dplyr::ungroup(),
        rfasst::m3_get_mort_o3(prj_name = prj_path,
                               final_db_year = max_year,
                               scen_name = sc,
                               saveOutput = F,
                               map = F, anim = F) %>%
          dplyr::mutate(scenario = sc) %>%
          dplyr::rowwise() %>%
          dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
          dplyr::group_by(year, scenario, region) %>%
          dplyr::summarise(value = sum(GBD2016)) %>%
          dplyr::ungroup()
        ) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, scenario, region) %>%
        dplyr::summarise(value = sum(value)) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(units = 'Number of premature deaths')
    )

    # Bind all the datasets together
    return_data <- dplyr::bind_rows(return_data)

    # If necessary, remove the region column
    if (!regional) {
      return_data <- return_data %>%
        dplyr::select(-region)
    }
  }

  return(return_data)
}
