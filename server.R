shinyServer(
    function(input, output, session) {

    observe({
        print(paste0("Selected ", input$path))
        if (input$path == "<select>") {
            return()
        }
        features <<- c("<select>")
        updateSelectInput(
            session = session,
            inputId = "feature",
            choices = features,
            selected = NULL)
        loadObject(input$path)
        features <<- listFeatures(session)
        updateSelectInput(
            session = session,
            inputId = "feature",
            choices = features)
    })
    
    observeEvent(input$reset.figure.size, {
        updateSliderInput(session, "plot.width", value = 1000)
        updateSliderInput(session, "plot.height", value = 600)
    })
    
    observeEvent(input$previous.feature, {
        if (length(input$feature) != 1) {
            showModal(
                modalDialog(
                    title = "For usage of this button, only one feature can be selected."
                )
            )
            return()
        }
        current <- which(features == input$feature)
        if (current < 0 || current > length(features)) {
            showModal(
                modalDialog(
                    title = "Selection out of range."
                )
            )
            return()
        }
        updateSelectInput(session, "feature", selected = features[current - 1])
    })

    observeEvent(input$next.feature, {
        if (length(input$feature) != 1) {
            showModal(
                modalDialog(
                    title = "For usage of this button, only one feature can be selected."
                )
            )
            return()
        }
        current <- which(features == input$feature)
        if (current < 0 || current > length(features)) {
            showModal(
                modalDialog(
                    title = "Selection out of range."
                )
            )
            return()
        }
        updateSelectInput(session, "feature", selected = features[current + 1])
    })

    output$mara.zfin.link <- renderUI({
        label <- ""
        url <- ""
        if (length(input$feature) == 1) {
            if (startsWith(input$feature, "MOTIF")) {
                motif <- gsub("^.*?_","", input$feature)
                url <- paste0(
                    "https://ismara.unibas.ch/ISMARA/scratch/jeff_yiqun_data_all_scMARA/report/pages/",
                    motif,
                    ".html"
                )
                label <- paste0("More details at ISMARA: ", motif)
            } else {
                url <- paste0(
                    "https://zfin.org/search?category=&q=",
                    input$feature
                )
                label <- paste0("More details at Zfin: ", input$feature)
            }
        }
        url.path <- a(label, href=url, target="_blank")
        return(tagList("", url.path))
    })

    output$tree2D <- renderPlot({
        if (length(input$feature) == 0) {
            plotTree(
                object,
                "segment"
            )
        } else if (length(input$feature) == 1) {
            if (startsWith(input$feature, "MOTIF")) {
                color.bar.limiit <- max(
                    abs(min(object@gene.sig.z[[input$feature]])),
                    max(object@gene.sig.z[[input$feature]]))
                plotTree(
                    object,
                    input$feature,
                    symmetric.color.scale=T,
                    color.limits = c(-color.bar.limiit, color.bar.limiit)
                )
            } else {
                plotTree(
                    object,
                    input$feature,
                )                
            }
        } else if  (length(input$feature) == 2) {
            plotTreeDual(
                object,
                input$feature[[1]],
                input$feature[[2]]
            )

        } else {
            p <- list()
            for(feat in input$feature){
                p[[which(feat == input$feature)]] <- plotTree(
                    object,
                    feat
                )
            }
            plots <- grid.arrange(grobs=p)
            print(plots)
        }
    })
    
    output$tree2D.ui <- renderUI({
        validate(
            need(
                input$path != "<select>",
                "Please select file to be laoded."
            )
        )
        plotOutput(
            "tree2D",
            height = input$plot.height,
            width = input$plot.width
        )
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
            } else if (length(input$feature) == 2) {
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
            } else {
                p <- list()
                for(feat in input$feature){
                    p[[which(feat == input$feature)]] <- plotTree(
                        object,
                        feat
                    )
                }
                plots <- grid.arrange(grobs=p)
                ggsave(
                    file,
                    plot = grid.arrange(grobs=p),
                    width = as.double(input$width),
                    height = as.double(input$height),
                    units = input$unit,
                    device = input$format
                )
            }
        }
    )
})