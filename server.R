shinyServer(
    function(input, output, session) {

    getFeatures = reactive({
        return(listFeatures())
    })

    observe({
        print(paste0("Selected ", input$path))
        if (input$path == "<select>") {
            return()
        }
        loadObject(input$path)
        updateSelectInput(
            session = session,
            inputId = "feature",
            choices = getFeatures())
    })

    output$tree2D <- renderPlot({
        validate(
            need(
                input$path != "<select>",
                "Please select file to be laoded."
            )
        )
        validate(
            need(
                length(input$feature) < 3,
                "Select at least up to 2 features to be plotted on the tree."
            )
        )
        if (length(input$feature) < 2) {
            plotTree(
                object,
                if (length(input$feature) == 1) input$feature else "segment"
            )
        } else {
            plotTreeDual(
                object,
                input$feature[[1]],
                input$feature[[2]]
            )

        }
    })

    output$downloadTree2D <- downloadHandler(
        filename = function() { paste0("tree_2D_plot_snapshot.", input$format) },
        content = function(file) {
            if (length(input$feature) < 2) {
                ggsave(
                    file,
                    plot = plotTree(
                        object,
                        if (length(input$feature) == 1) input$feature else "segment"
                    ),
                    width = as.double(input$width),
                    height = as.double(input$height),
                    units = input$unit,
                    device = input$format
                )
            } else {
                ggsave(
                    file,
                    plot = plotTreeDual(
                        object,
                        input$feature[[1]],
                        input$feature[[2]]
                    ),
                    width = as.double(input$width),
                    height = as.double(input$height),
                    units = input$unit,
                    device = input$format
                )
            }
        }
    )
})