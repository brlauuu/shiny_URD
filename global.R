# Load all libraries
options(rgl.useNULL = TRUE, width = 1200, spinner.type = 1, spinner.color = "#1DA1F2")
library(URD)
library(shiny)
library(shinycssloaders)
library(rgl)
library(rglwidget)
library(ggplot2)

urd.version <<- packageVersion("URD")

f <- list.files("data")
path.to.load <- c("<select>", f[grepl(".*rds", f)])
features <- c("<select>")

units <- c("mm", "cm", "in")
device <- c("png", "eps", "ps", "tex", "pdf", "jpeg", "tiff", "bmp", "svg")

object <- NULL

loadObject <- function(path) {
	object <<- readRDS(paste0("data/", path))
	print(paste0("Loaded URD object from path: ", "data/", path))
}

listFeatures <- function() {
	tryCatch({
		return(
			c(
				"pseudotime",
				colnames(object@meta),
				rownames(object@logupx.data)
			)
		)
	}, error=function(cond) {
		print(paste("Invalid URD file loaded:", "data/", path))
		print("Here's the original error message:")
		print(cond)
		return("<select>")
	})
}