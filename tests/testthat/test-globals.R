library(rfasst)


context("globals")


test_that("globals:  color SSP scale", {

  globalSSPColorScales <- get_globalSSPColorScales()

  testthat::expect_equal(globalSSPColorScales,
                         c("GCAM_SSP1" = "#5DBFDE", "GCAM_SSP2" = "#5CB95C", "GCAM_SSP3" = "#FBAB33",
                                       "GCAM_SSP4" ="#D7534E", "GCAM_SSP5" ="#9E49D1"))

})

test_that("globals:  color custom scale", {

  globalCustomColorScales <- get_globalCustomColorScales()

  testthat::expect_equal(globalCustomColorScales,
                         c("#5DBFDE","#5CB95C","#FBAB33","#D7534E","#9E49D1"))

})


test_that("globals:  get example prj", {

  globalExamplePrj <- get_example_prj()

  testthat::expect_equal(globalExamplePrj,
                         get(load(file.path(rprojroot::find_root(rprojroot::is_testthat),"test_results","globalExamplePrj.RData"))))

})

test_that("globals:  get queries", {

  globalQueries <- get_queries()

  testthat::expect_equal(globalQueries,
                         get(load(file.path(rprojroot::find_root(rprojroot::is_testthat),"test_results","globalQueries.RData"))))

})


test_that("globals:  global capabilities", {

  globalCapabilities <- get_globalCapabilities()

  expect_equal(globalCapabilities[['emissions_bc']][1], 'emissions_bc')
  expect_equal(attributes(globalCapabilities[['emissions_bc']])$longName, 'BC emissions')

  expect_equal(globalCapabilities[['emissions_nh3']][1], 'emissions_nh3')
  expect_equal(attributes(globalCapabilities[['emissions_nh3']])$longName, 'NH3 emissions')

  expect_equal(globalCapabilities[['emissions_nmvoc']][1], 'emissions_nmvoc')
  expect_equal(attributes(globalCapabilities[['emissions_nmvoc']])$longName, 'NMVOC emissions')

  expect_equal(globalCapabilities[['emissions_nox']][1], 'emissions_nox')
  expect_equal(attributes(globalCapabilities[['emissions_nox']])$longName, 'NOx emissions')

  expect_equal(globalCapabilities[['emissions_pom']][1], 'emissions_pom')
  expect_equal(attributes(globalCapabilities[['emissions_pom']])$longName, 'POM emissions')

  expect_equal(globalCapabilities[['emissions_so2']][1], 'emissions_so2')
  expect_equal(attributes(globalCapabilities[['emissions_so2']])$longName, 'SO2 emissions')

  expect_equal(globalCapabilities[['concentration_pm25']][1], 'concentration_pm25')
  expect_equal(attributes(globalCapabilities[['concentration_pm25']])$longName, 'PM25 concentration')

  expect_equal(globalCapabilities[['concentration_o3']][1], 'concentration_o3')
  expect_equal(attributes(globalCapabilities[['concentration_o3']])$longName, 'O3 concentration')

  expect_equal(globalCapabilities[['health_deaths_pm25']][1], 'health_deaths_pm25')
  expect_equal(attributes(globalCapabilities[['health_deaths_pm25']])$longName, 'Premature deaths due to PM25')

  expect_equal(globalCapabilities[['health_deaths_o3']][1], 'health_deaths_o3')
  expect_equal(attributes(globalCapabilities[['health_deaths_o3']])$longName, 'Premature deaths due to O3')

  expect_equal(globalCapabilities[['health_deaths_total']][1], 'health_deaths_total')
  expect_equal(attributes(globalCapabilities[['health_deaths_total']])$longName, 'Total premature deaths')

  expect_equal(globalCapabilities[['agriculture_ryl_mi']][1], 'agriculture_ryl_mi')
  expect_equal(attributes(globalCapabilities[['agriculture_ryl_mi']])$longName, 'Agriculture relative yield loss')

  expect_equal(globalCapabilities[['agriculture_prod_loss']][1], 'agriculture_prod_loss')
  expect_equal(attributes(globalCapabilities[['agriculture_prod_loss']])$longName, 'Agriculture production loss')

  expect_equal(globalCapabilities[['agriculture_rev_loss']][1], 'agriculture_rev_loss')
  expect_equal(attributes(globalCapabilities[['agriculture_rev_loss']])$longName, 'Agriculture revenue loss')
})
