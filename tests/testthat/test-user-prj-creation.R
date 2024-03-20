# library(rfasst)
#
#
# context("prj creation")
#
# test_that("prj creation:  data query", {
#
#   # download prj
#   db_path <- file.path(rprojroot::find_root(rprojroot::is_testthat), "www")
#   rpackageutils::download_unpack_zip(
#     data_directory = db_path,
#     url = "https://zenodo.org/record/10258919/files/database_basexdb_ref.zip?download=1"
#   )
#   testthat::expect_equal(1, 1)
#
#   # create the prj
#   db_name <- "database_basexdb_ref"
#   prj_name <- "rfasstui_test.dat"
#   scenarios <- "Reference"
#   # query_path <- file.path(rprojroot::find_root(rprojroot::is_testthat), "www", "input", "queries")
#
#
#   print(db_path)
#   print(db_name)
#   conn <- rgcam::localDBConn(db_path,'database_basexdb_ref')
#   conn <- rgcam::localDBConn(file.path(rprojroot::find_root(rprojroot::is_testthat)),'database_basexdb_ref')
#   print(conn)
#
#   # dt <- data_query(db_path, db_name, prj_name, scenarios, query_path,
#   #                  query_file = 'queries_rfasst_nonCO2.xml')
#
#   # testthat::expect_equal(dt,
#   #                        get(load(file.path(rprojroot::find_root(rprojroot::is_testthat),"test_results","dt.RData"))))
#
# })
#
