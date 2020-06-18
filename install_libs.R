if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, rgl, rglwidget, shinycssloaders, devtools, shinyjs, install = TRUE)

if (!require("URD")) install_github(repo = "farrellja/URD", ref = "debug")
