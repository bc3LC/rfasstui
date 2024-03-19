library(magrittr)

# Compute the desired map given a dataset

#' Compute health, agricultural, or economic map
#'
#' @param map_data dataset from rfasst
#' @param variable desired output:
#' emissions_bc, emissions_nh3, emissions_nmvoc, emissions_nox, emissions_pom, emissions_so2
#' concentration_pm25, concentration_o3,
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
  save(map_data, file = 'map_data.RData')

  if (grepl('emissions', variable)) {
    print('in emissions')

    emiss.map <- map_data %>%
      dplyr::rename(subRegion=region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(units="Gg",
                    value=value*1E-6,
                    year=as.numeric(as.character(year)))

    # Filter the selected pollutant
    poll <- strsplit(variable, "_")[[1]][2]
    emiss.map <- emiss.map %>%
      dplyr::filter(tolower(pollutant) == tolower(poll))

    map_figure <- rmap::map(data = emiss.map,
                            shape = fasstSubset,
                            legendType = "pretty",
                            background = T,
                            save = F, animate = F,
                            title = map_title)

  }
  else if (variable == 'concentration_pm25') {
    print('in concentration_pm25')

    pm25.map <- map_data %>%
      dplyr::rename(subRegion=region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(units="ug/m3",
                    year=as.numeric(as.character(year)))

    map_figure <- rmap::map(data = pm25.map,
                            shape = fasstSubset,
                            legendType = "pretty",
                            background  = T,
                            save = F, animate = F,
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
  else if (grepl('health', variable)) {
    print('in health')

    health.map <- map_data %>%
      dplyr::rename(subRegion = region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(year = as.numeric(as.character(year)),
                    units = "Premature deaths")

    map_figure <- rmap::map(data = health.map,
                  shape = fasstSubset,
                  legendType = "pretty",
                  background  = T,
                  save = F,
                  title = map_title)
  }
  else if (grepl('agriculture', variable)) {
    print('in agriculture')

    ag.map <- map_data %>%
      dplyr::rename(subRegion = region)%>%
      dplyr::filter(subRegion != "RUE") %>%
      dplyr::mutate(year = as.numeric(as.character(year)))

    map_figure <- rmap::map(data = ag.ryl.map,
                  shape = fasstSubset,
                  ncol = 2,
                  legendType = "pretty",
                  background  = T,
                  save = F,
                  title = map_title)
  }
  return(map_figure)
}




# Compute the desired output given a GCAM project

#' Compute health, agricultural, or economic output. Define only prj_data or prj, but not both!
#'
#' @param prj_data standard scenario project data
#' @param prj custom scenario loaded project
#' @param variable desired output:
#' emissions_bc, emissions_nh3, emissions_nmvoc, emissions_nox, emissions_pom, emissions_so2
#' concentration_pm25, concentration_o3,
#' health_deaths_pm25, health_deaths_o3, health_deaths_total,
#' agricultural_rel_yield_loss, TODO
#' economic_vsl TODO
#' @param scen vecotr of the scenario names to be considered
#' @param regional TRUE if dataset grouped by region, FALSE if only the World region is considered
#' @return dataset
#' @importFrom magrittr %>%
#' @export
computeOutput <- function(prj_data = NULL, prj = NULL, variable, scen, regional = FALSE)
{
  print('in compute output')

  if (!is.null(prj_data)) {
    prj_name <- names(prj_data)
    prj_path <- prj_data[[prj_name]]$path
    prj <- rgcam::loadProject(prj_path)
    max_year <- max(prj[[scen[1]]][['ag production by crop type']][['year']])
    # if scenarios where selected, (in the case of the SSP example prj), plot only this ones
  } else {
    # remote "data" from the scenario list
    scen <- scen[!grepl("data", scen)]
    max_year <- max(prj[[scen[1]]][['ag production by crop type']][['year']])
  }

  if (grepl('emissions', variable)) {
    print('in emissions')
    return_data <- lapply(scen, function(sc)
      dplyr::bind_rows(rfasst::m1_emissions_rescale(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                                   prj = if (is.null(prj_data)) prj else NULL,
                                   final_db_year = max_year,
                                   scen_name = sc,
                                   saveOutput = F,
                                   map = F, anim = F,
                                   recompute = T)) %>%
        dplyr::mutate(scenario = sc) %>%
        dplyr::mutate(units = 'Gg') %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = dplyr::if_else(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, scenario, units, pollutant, region) %>%
        dplyr::summarise(value = median(value)) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(pollutant = dplyr::if_else(
          pollutant == "NOX", "NOx", dplyr::if_else(
          pollutant == "OM", "POM", dplyr::if_else(
          pollutant == "VOC", "NMVOC", pollutant))))
    )

    # Bind all the datasets together
    return_data <- dplyr::bind_rows(return_data)

    # If necessary, remove the region column
    if (!regional) {
      return_data <- return_data %>%
        dplyr::select(-region)
    }

    # Filter the selected pollutant
    poll <- strsplit(variable, "_")[[1]][2]
    return_data <- return_data %>%
      dplyr::filter(tolower(pollutant) == tolower(poll))
  }
  else if (variable == 'concentration_pm25') {
    print('in concentration_pm25')
    return_data <- lapply(scen, function(sc)
      rfasst::m2_get_conc_pm25(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                               prj = if (is.null(prj_data)) prj else NULL,
                               final_db_year = max_year,
                               scen_name = sc,
                               saveOutput = F,
                               map = F, anim = F,
                               recompute = T) %>%
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
      rfasst::m2_get_conc_o3(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                             prj = if (is.null(prj_data)) prj else NULL,
                             final_db_year = max_year,
                             scen_name = sc,
                             saveOutput = F,
                             map = F, anim = F,
                             recompute = T) %>%
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
      rfasst::m3_get_mort_pm25(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                               prj = if (is.null(prj_data)) prj else NULL,
                               final_db_year = max_year,
                               scen_name = sc,
                               saveOutput = F,
                               map = F, anim = F,
                               recompute = T) %>%
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
      rfasst::m3_get_mort_o3(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                             prj = if (is.null(prj_data)) prj else NULL,
                             final_db_year = max_year,
                             scen_name = sc,
                             saveOutput = F,
                             map = F, anim = F,
                             recompute = T) %>%
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
        rfasst::m3_get_mort_pm25(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                                 prj = if (is.null(prj_data)) prj else NULL,
                                 final_db_year = max_year,
                                 scen_name = sc,
                                 saveOutput = F,
                                 map = F, anim = F,
                                 recompute = T) %>%
          dplyr::mutate(scenario = sc) %>%
          dplyr::rowwise() %>%
          dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
          dplyr::group_by(year, scenario, region) %>%
          dplyr::summarise(value = sum(GBD)) %>%
          dplyr::ungroup(),
        rfasst::m3_get_mort_o3(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                               prj = if (is.null(prj_data)) prj else NULL,
                               final_db_year = max_year,
                               scen_name = sc,
                               saveOutput = F,
                               map = F, anim = F,
                               recompute = F) %>%
          dplyr::mutate(scenario = sc) %>%
          dplyr::rowwise() %>%
          dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
          dplyr::group_by(year, scenario, region) %>%
          dplyr::summarise(value = sum(GBD2016)) %>%
          dplyr::ungroup()
        ) %>%
        dplyr::rowwise() %>%
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
  else if (variable == 'agriculture_ryl_mi') {
    print('in agriculture_ryl_mi')
    return_data <- lapply(scen, function(sc)
      rfasst::m4_get_ryl_mi(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                            prj = if (is.null(prj_data)) prj else NULL,
                            final_db_year = max_year,
                            scen_name = sc,
                            saveOutput = F,
                            map = F, anim = F,
                            recompute = T) %>%
        dplyr::mutate(scenario = sc) %>%
        dplyr::rename(units = unit) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, units, pollutant, scenario, region) %>%
        dplyr::summarise(value = sum(value)) %>%
        dplyr::ungroup() %>%
        dplyr::rename(class = pollutant) %>%
        dplyr::mutate(class = gsub("M_", "", class)))

    # Bind all the datasets together
    return_data <- dplyr::bind_rows(return_data)

    # If necessary, remove the region column
    if (!regional) {
      return_data <- return_data %>%
        dplyr::select(-region)
    }
  }
  else if (variable == 'agriculture_prod_loss') {
    print('in agriculture_prod_loss')
    return_data <- lapply(scen, function(sc)
      rfasst::m4_get_prod_loss(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                               prj = if (is.null(prj_data)) prj else NULL,
                               final_db_year = max_year,
                               scen_name = sc,
                               saveOutput = F,
                               map = F, anim = F,
                               recompute = T) %>%
        dplyr::mutate(scenario = sc) %>%
        dplyr::rename(units = unit) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, units, pollutant, scenario, region) %>%
        dplyr::summarise(value = sum(value)) %>%
        dplyr::ungroup() %>%
        dplyr::rename(class = pollutant) %>%
        dplyr::mutate(class = gsub("M_", "", class)))

    # Bind all the datasets together
    return_data <- dplyr::bind_rows(return_data)

    # If necessary, remove the region column
    if (!regional) {
      return_data <- return_data %>%
        dplyr::select(-region)
    }
  }
  else if (variable == 'agriculture_rev_loss') {
    print('in agriculture_rev_loss')
    return_data <- lapply(scen, function(sc)
      rfasst::m4_get_rev_loss(prj_name = if (!is.null(prj_data)) prj_data else 'dummy.dat',
                              prj = if (is.null(prj_data)) prj else NULL,
                              final_db_year = max_year,
                              scen_name = sc,
                              saveOutput = F,
                              map = F, anim = F,
                              recompute = T) %>%
        dplyr::mutate(scenario = sc) %>%
        dplyr::rename(units = unit) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(region = ifelse(regional, region, 'dummy_reg')) %>%
        dplyr::group_by(year, units, pollutant, scenario, region) %>%
        dplyr::summarise(value = sum(value)) %>%
        dplyr::ungroup() %>%
        dplyr::rename(class = pollutant) %>%
        dplyr::mutate(class = gsub("M_", "", class)))

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
