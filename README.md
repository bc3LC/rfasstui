[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

#  rfasstUI

A web-based interactive scenario builder and visualization application for the rfasst air pollution model

## Using `rfasstui`

Just getting started with `rfasstui`?  We have constructed a tutorial to examine some sample use-cases which are available here:  [Tutorial](https://bc3lc.github.io/rfasstui/articles/tutorial.html)

To navigate directly to the `rfasstui` app **CLICK the following image**:

[![`rfasstui` map scenario interface](https://raw.githubusercontent.com/bc3LC/rfasstui/main/vignettes/readme_figures/rfasstui_web.png)](https://bc3lc.shinyapps.io/rfasstui/)

## Installing Locally

To install `rfasstui` as an R package for local use, please follow these steps in your R command line:

```R
library(devtools)
devtools::install_github("bc3LC/rfasstui")
```

## Developing Locally
How you launch the app after installation depends on your R environment.  See the following.

#### For RStudio Users
If you are using RStudio, simply open the `server.r` or `ui.r` file and execute `Run App`.

#### For CMD Users
Start `R.exe` and enter the following command:

```R
shiny::runApp(system.file("shinyApp", package = "rfasstui"))
```

#### Adding New Features
Users familiar with R Shiny can add new features by working directly in the `rfasstui/inst/shinyApp` directory.

## Contributing to `rfasstui`

We welcome contributions to `rfasstui` from the development community. Join in 
on the conversation at the [`rfasstui` GitHub Discussions page](https://github.com/bc3LC/rfasstui/issues) or contact us if you want to
collaborate!

For more information about contributing, please contact Clàudia Rodés-Bachs at claudia.rodes@bc3research.org or Jon Sampedro at jon.sampedro@bc3research.org

## Learn More About Rfasst
Read more about the Rfasst air pollution model here:  [`rfasst` Documentation](https://bc3lc.github.io/rfasst/). `Rfasst` has been published in the following:

```
Sampedro et al., (2022). rfasst: An R tool to estimate air pollution impacts on health and agriculture. Journal of Open Source Software, 7(69), 3820, https://doi.org/10.21105/joss.03820
```
