library(markdown)

navbarPage("Shiny URD",
        tabPanel("Tree",
            sidebarLayout(
              sidebarPanel(
                helpText(paste0("URD v", urd.version)),
                selectInput(
                  "path",
                  "Select file",
                  choices=path.to.load),
                selectInput(
                  "feature",
                  "Select feature(s)",
                  choices=features,
                  multiple = T),
                selectInput(
                  "format",
                  "Downlaod format",
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
                withSpinner(plotOutput("tree2D"))
              )
            )
        ),
        tabPanel("About",
            includeMarkdown("README.md")
        )
)