library(markdown)

navbarPage("Shiny URD",
        tabPanel("Tree",
            sidebarLayout(
              sidebarPanel(
              	helpText(paste0("URD v", urd.version)),
              	tags$div(class="header", checked=NA,
              			 tags$h3("Select files and features:")
              	),
              	selectInput(
                  "path",
                  "File",
                  choices=path.to.load),
                selectInput(
                  "feature",
                  "Feature(s)",
                  choices=features,
                  multiple = T),
                actionButton("previous.feature", "Previous feature"),
                actionButton("next.feature", "Next feature"),
                uiOutput("mara.zfin.link"),
                tags$div(class="header", checked=NA,
                		 tags$h3("Plot size in pixels:")
                ),
                sliderInput("plot.width", "Width:",
                			min = 0, max = 4000,
                			value = 1000),
                sliderInput("plot.height", "Height:",
                			min = 0, max = 4000,
                			value = 600),
                actionButton("reset.figure.size", "Reset"),
                tags$div(class="header", checked=NA,
                		 tags$h3("Download:")
                ),
                selectInput(
                  "format",
                  "Format",
                  choices=device),
                selectInput(
                  "unit",
                  "Size units",
                  choices=units),
                textInput("height", "Height", "200"),
                textInput("width", "Width", "400"),
                downloadButton(
                  "downloadTree2D",
                  label = "Tree 2D"
                ),
                width = "3"
              ),
              mainPanel(
              	withSpinner(uiOutput("tree2D.ui"))
              )
            )
        ),
        tabPanel("About",
            includeMarkdown("README.md")
        )
)