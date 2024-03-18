#' data_query
#'
#' Add nonCO2 large queries
#' @param db_path: path of the database
#' @param db_name: name of the database
#' @param prj_name: name of the project
#' @param scenarios: name of the scenarios to be considered
#' @param query_path: path to the queries file
#' @param query_file: queries file name
#' @return dataframe with the data from the query
#' @export
data_query = function(db_path, db_name, prj_name, scenarios, query_path,
                      queries_file = 'queries_rfasst_nonCO2.xml') {
  dt = data.frame()
  xml <- xml2::read_xml(file.path(query_path,query_file))
  qq <- xml2::xml_find_first(xml, paste0("//*[@title='", type, "']"))

  type = 'nonCO2 emissions by sector (excluding resource production)'

  # retrive nonCO2 pollutants
  emiss_list <- c("BC","BC_AWB","C2F6","CF4","CH4","CH4_AGR","CH4_AWB","CO",
                  "CO_AWB","HFC125","HFC134a","HFC143a","HFC152a","HFC227ea",
                  "HFC23","HFC236fa","HFC245fa","HFC32","HFC365mfc","N2O",
                  "N2O_AGR","N2O_AWB","NH3","NH3_AGR","NH3_AWB","NMVOC",
                  "NMVOC_AWB","NOx","NOx_AGR","NOx_AWB","OC","OC_AWB","SF6",
                  "SO2_1","SO2_1_AWB","SO2_2","SO2_2_AWB","SO2_3","SO2_3_AWB",
                  "SO2_4","SO2_4_AWB")
  for (sc in scenarios) {
    while (length(emiss_list) > 0) {
      current_emis = emiss_list[1:min(21,length(emiss_list))]
      qq_sec = gsub("current_emis", paste0("(@name = '", paste(current_emis, collapse = "' or @name = '"), "')"), qq)

      prj_tmp = rgcam::addSingleQuery(
        conn = rgcam::localDBConn(db_path,
                                  db_name,migabble = FALSE),
        proj = prj_name,
        qn = type,
        query = qq_sec,
        scenario = sc,
        regions = NULL,
        clobber = TRUE,
        transformations = NULL,
        saveProj = FALSE,
        warn.empty = FALSE
      )

      tmp = data.frame(prj_tmp[[sc]][type])
      if (nrow(tmp) > 0) {
        dt = dplyr::bind_rows(dt,tmp)
      }
      rm(prj_tmp)

      if (length(emiss_list) > 21) {
        emiss_list <- emiss_list[(21 + 1):length(emiss_list)]
      } else {
        emiss_list = c()
      }
    }
  }
  # Rename columns
  new_colnames <- sub(".*\\.(.*)", "\\1", names(dt))
  names(dt) <- new_colnames

  return(dt)
}


#' fill_queries
#'
#' Create a folder to save the datasets and file, in case it does not exist
#' @param prj: current project
#' @param db_path: path of the database
#' @param db_name: name of the database
#' @param prj_name: name of the project
#' @param scenarios: name of the scenarios to be considered
#' @param query_path: path to the queries file
#' @param query_file: queries file name
#' @return prj containing the nonCO2 emissions by sector
#' @export
fill_queries = function(prj, db_path, db_name, prj_name, scenarios, query_path,
                        query_file = 'queries_rfasst_nonCO2.xml') {

  # add nonCO2 query manually (it is too big to use the usual method)
  if (!'nonCO2 emissions by sector (excluding resource production)' %in% rgcam::listQueries(prj)) {
    dt_sec <- data_query(db_path, db_name, prj_name, scenarios, query_path, query_file)
    prj_tmp <- rgcam::addQueryTable(project = prj_name, qdata = dt_sec,
                                    queryname = 'nonCO2 emissions by sector (excluding resource production)', clobber = FALSE)
    prj <- rgcam::mergeProjects(prj_name, list(prj,prj_tmp), clobber = TRUE, saveProj = FALSE)
  }

  return(prj)
}

