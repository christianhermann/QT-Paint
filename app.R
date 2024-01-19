library(shiny)
library(readr)
library(svDialogs)
library(ggthemes)
library(ggplot2)
library(tidyr)
library(latex2exp)
library(colourpicker)
library(ggprism)
library(esquisse)
library(shinyFiles)
library(rChoiceDialogs)


CTcurve <- data.frame()
active_plot <- c()

theme_CTcurve <- function(base_size = 11,
                          axis_size = 10,
                          axeSize = 0.7,
                          base_family = "sans") {
  theme_foundation(base_size = base_size, base_family = base_family) %+replace%
    theme(
      legend.key = element_blank(),
      legend.title = element_blank(),
      axis.text.x = element_text(color = "black", size = axis_size),
      axis.text.y = element_text(
        color = "black",
        hjust = 1,
        size = axis_size,
        margin = margin(r = 5)
      ),
      axis.text = element_text(color = "black",
                               size = axis_size),
      panel.background = element_blank(),
      plot.background = element_blank(),
      panel.border = element_blank(),
      axis.line = element_line(colour = "black", linetype = "solid", size = axeSize),
      plot.margin = margin(1, 1, 0.2, 0.2, "cm"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank(),
      legend.position = "none",
      axis.ticks = element_line(colour = "black", size = axeSize),
      axis.ticks.length=unit(axeSize*1.5, "mm")
    )
}

ui <- function(request) {
  fluidPage(titlePanel("QT-Paint"),
            
            sidebarLayout(
              sidebarPanel(
                numericInput("Offset", "Offset", 0),
                numericInput("Cm", "Cm", 0),
                actionButton("Calculate", "Calculate Corrected Means"),
                hr(),
                column(4, numericInput("P1_Start", "P1-Start", 1)),
                column(4, numericInput("P1_End", "P1-End", 1)),
                column(4, numericInput("P1_Height", "P1-Height", 0)),
                column(6, textInput("P1_Label", "P1")),
                column(6, colourInput("P1_col", "Select colour", "blue")),
                column(4, numericInput("P2_Start", "P2-Start", 1)),
                column(4, numericInput("P2_End", "P2-End", 1)),
                column(4, numericInput("P2_Height", "P2-Height", 0)),
                column(6, textInput("P2_Label", "P2")),
                column(6, colourInput("P2_col", "Select colour", "green")),
                column(4, numericInput("P3_Start", "P3-Start", 1)),
                column(4, numericInput("P3_End", "P3-End", 1)),
                column(4, numericInput("P3_Height", "P3-Height", 0)),
                column(6, textInput("P3_Label", "P3")),
                column(6, colourInput("P3_col", "Select colour", "red")),
                column(4, numericInput("P4_Start", "P4-Start", 1)),
                column(4, numericInput("P4_End", "P4-End", 1)),
                column(4, numericInput("P4_Height", "P4-Height", 0)),
                column(6, textInput("P4_Label", "P4")),
                column(6, colourInput("P4_col", "Select colour", "yellow")),
                fluidRow()
              )
              ,
              mainPanel(
                actionButton("ChangeWorkspace", "Change Workspace"),
                shinyFilesButton("Import_ASC", "Import .ASC", 'Please select a file', FALSE),
                shinyFilesButton("Import_CSV", "Import .CSV", 'Please select a file', FALSE),
                shinyFilesButton("Import_R", "Import .rData", 'Please select a file', FALSE),
                shinySaveButton("Save_CSV", "Save .CSV", filetype=list(xlsx="csv"), FALSE),
                shinySaveButton("Save_R", "Save .rData", filetype=list(rData="rData"), FALSE),
                actionButton("Save_Image", "Save Plot"),
                
                hr(),
                fluidRow(
                  column(
                    width = 2,
                    numericInput(
                      "Save_width",
                      "Width",
                      value = 300,
                      min = 0,
                      max = 10000,
                      step = 0.1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "Save_height",
                      "Heigth",
                      value = 300,
                      min = 0,
                      max = 10000,
                      step = 0.1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "yMax",
                      "y-Max",
                      value = 1000,
                      min = 0,
                      max = 100000,
                      step = 1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "yMin",
                      "y-Min",
                      value = -1000,
                      min = -100000,
                      max = 0,
                      step = 1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "xMax",
                      "x-Max",
                      value = "",
                      min = 0,
                      max = 100000,
                      step = 1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "xMin",
                      "x-Min",
                      value = "",
                      min = -1000,
                      max = 100000,
                      step = 1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "FontSize",
                      "FontSize",
                      value = 10,
                      min = 0,
                      max = 50,
                      step = 0.1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "FontSize_Axis",
                      "FontSize Axis",
                      value = 11,
                      min = 0,
                      max = 50,
                      step = 0.1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "LineSize",
                      "LineSize",
                      value = 1,
                      min = 0,
                      max = 5,
                      step = 0.1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "PlotLineSize",
                      "PlotLineSize",
                      value = 0.7,
                      min = 0,
                      max = 5,
                      step = 0.1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "xlineSize",
                      "xLineSize",
                      value = 0.7,
                      min = 0,
                      max = 5,
                      step = 0.1
                    )
                  ),
                  column(
                    width = 2,
                    numericInput(
                      "axisSize",
                      "axisSize",
                      value = 0.7,
                      min = 0,
                      max = 5,
                      step = 0.1
                    )
                  )
                ),
                hr(),
                tabsetPanel(
                  id = "tab",
                  tabPanel("Data",                 DT::dataTableOutput("DF_CTcurve")),
                  tabPanel("Plot",                 plotOutput("CTcurvePlot"))
                  
                )
              )
            ))
}


server <- function(input, output, session) {
  rv <- reactiveValues(plot = NULL)
  
  volumes <-
    c(
      Workspace = getwd(),
      Home = fs::path_home(),
      "R Installation" = R.home(),
      getVolumes()()
    )
  shinyFileChoose(
    input,
    "Import_ASC",
    roots = volumes,
    session = session,
    restrictions = system.file(package = "base"),
    filetypes = c('', 'asc')
  )
  shinyFileChoose(
    input,
    "Import_CSV",
    roots = volumes,
    session = session,
    restrictions = system.file(package = "base"),
    filetypes = c('', 'csv')
  )
  shinyFileChoose(
    input,
    "Import_R",
    roots = volumes,
    session = session,
    restrictions = system.file(package = "base"),
    filetypes = c('', 'rData')
  )
  shinyFileSave(
    input,
    "Save_CSV",
    roots = volumes,
    session = session,
    restrictions = system.file(package = "base")
  )
  shinyFileSave(
    input,
    "Save_R",
    roots = volumes,
    session = session,
    restrictions = system.file(package = "base")
  )
  
  observe({
    id <- input$tab
    ymin <- input$yMin
    ymin_orig <- ymin
    ymax <- input$yMax
    ymin - (abs(ymin) + abs(ymax)) * 0.03
    width = input$Save_width
    height = input$Save_height
    
    P1_Start <- CTcurve$Time[CTcurve$Sweep == input$P1_Start]
    P1_End <- CTcurve$Time[CTcurve$Sweep == input$P1_End]
    
    P2_Start <- CTcurve$Time[CTcurve$Sweep == input$P2_Start]
    P2_End <- CTcurve$Time[CTcurve$Sweep == input$P2_End]
    
    P3_Start <- CTcurve$Time[CTcurve$Sweep == input$P3_Start]
    P3_End <- CTcurve$Time[CTcurve$Sweep == input$P3_End]
    
    P4_Start <- CTcurve$Time[CTcurve$Sweep == input$P4_Start]
    P4_End <- CTcurve$Time[CTcurve$Sweep == input$P4_End]
    
    if (length(CTcurve) > 0) {
      plot_data <-
        cbind(gather(CTcurve[, c(5, 6)], meanType, meanValue), time = CTcurve$Time)
      active_plot <-
        ggplot() + geom_line(
          data = plot_data,
          aes(
            x = time,
            y = meanValue,
            colour = meanType
          ),
          linewidth = input$PlotLineSize
        ) +
        theme_CTcurve(input$FontSize_Axis, input$FontSize_Axis - 1, axeSize = input$axisSize) + geom_hline(yintercept = 0, linewidth = input$xlineSize) +
        ylab(TeX("Curr. dens. (pA pF$^{-1})$")) +
        xlab("Time (s)") + scale_color_manual(values = c("black", "black"))
      
      active_plot <-
        active_plot + geom_segment(
          aes(
            x = P1_Start,
            xend = P1_End,
            y = input$P1_Height,
            yend = input$P1_Height
          ),
          colour = input$P1_col,
          linewidth = input$LineSize
        )
      active_plot <-
        active_plot + geom_text(
          aes(
            x = (P1_Start + P1_End) / 2,
            y = input$P1_Height
          ),
          label = input$P1_Label,
          vjust = -0.2,
          colour = input$P1_col,
          size = input$FontSize * 0.36
        )
      
      active_plot <-
        active_plot + geom_segment(
          aes(
            x = P2_Start,
            xend = P2_End,
            y = input$P2_Height,
            yend = input$P2_Height
          ),
          colour = input$P2_col,
          linewidth = input$LineSize
        )
      active_plot <-
        active_plot + geom_text(
          aes(
            x = (P2_Start + P2_End) / 2,
            y = input$P2_Height
          ),
          label = input$P2_Label,
          vjust = -0.2,
          colour = input$P2_col,
          size = input$FontSize * 0.36
        )
      
      active_plot <-
        active_plot + geom_segment(
          aes(
            x = P3_Start,
            xend = P3_End,
            y = input$P3_Height,
            yend = input$P3_Height
          ),
          colour = input$P3_col,
          linewidth = input$LineSize
        )
      active_plot <-
        active_plot + geom_text(
          aes(
            x = (P3_Start + P3_End) / 2,
            y = input$P3_Height
          ),
          label = input$P3_Label,
          vjust = -0.2,
          colour = input$P3_col,
          size = input$FontSize * 0.36
        )
      
      active_plot <-
        active_plot + geom_segment(
          aes(
            x = P4_Start,
            xend = P4_End,
            y = input$P4_Height,
            yend = input$P4_Height
          ),
          colour = input$P4_col,
          linewidth = input$LineSize
        )
      active_plot <-
        active_plot + geom_text(
          aes(
            x = (P4_Start + P4_End) / 2,
            y = input$P4_Height
          ),
          label = input$P4_Label,
          vjust = -0.2,
          colour = input$P4_col,
          size = input$FontSize * 0.36
        )
      
      
      xmin <- 0 - max(active_plot$layers[[1]]$data$time) * 0.03
      xmax <- max(active_plot$layers[[1]]$data$time)
      if (!is.na(input$xMin) && !is.na(input$xMax)) {
        xmin <- input$xMin
        xmax <- input$xMax
      }
      active_plot <-
        active_plot + scale_x_continuous(limits = c(xmin, xmax),
                                         expand = expansion(mult = c(0, 0))) +
        coord_cartesian(ylim = c(ymin, ymax), expand = F) +
        guides(y = "prism_offset_minor", x  = "prism_offset_minor")
      # active_plot <- active_plot + geom_segment(aes(
      #   x = xmin,
      #   y = ymin_orig,
      #   xend = xmin,
      #   yend = ymax
      # )) + geom_segment(aes(
      #   x = 0,
      #   y = ymin,
      #   xend = 0,
      #   yend = ymin
      # )) + scale_y_continuous() +
      #  coord_cartesian(ylim = c(ymin, ymax), expand = F)
      
      
      
      
      active_plot <<- active_plot
      rv$plot <- active_plot
      output$CTcurvePlot <- renderPlot(
        active_plot,
        width = input$Save_width,
        height = input$Save_height,
        res = 72
      )
      
    }
  })
  
  save_ggplot_server("save", rv)
  observeEvent(input$Import_ASC, {
    fileinfo <- parseFilePaths(volumes, input$Import_ASC)
    if (nrow(fileinfo) > 0) {
      try({
        CTcurve <-
          read_csv(
            as.character(fileinfo$datapath),
            col_types = cols(Max = col_skip(), `Mean[A]` = col_double()),
            locale = locale(),
            skip = 1
          )
        
        colnames(CTcurve) <- c("Sweep", "Time", "MeanMin", "MeanMax")
        CTcurve$MeanMinCorrected <- 0
        CTcurve$MeanMaxCorrected <- 0
        CTcurve <<- CTcurve
        
        output$DF_CTcurve <-
          DT::renderDataTable(CTcurve,
                              options = list(
                                escape = F,
                                scrollX = T,
                                scrollY = 500
                              ))
      })
    }
  }, ignoreInit = T)
  
  
  
  observeEvent(input$Save_Image, {
    # ggsave(
    #   paste0(dlgSave(title = "Save Plot")$res, ".", input$Filetype),
    #   active_plot ,
    #   device = input$Filetype,
    #   width = input$Save_width,
    #   height = input$Save_height,
    #   dpi = 300,
    #   units = "mm",
    #   limitsize = F
    # )
    save_ggplot_modal("save", "Save plot")
  }, ignoreInit = T)
  
  observeEvent(input$Calculate, {
    CTcurve$MeanMinCorrected <-
      ((CTcurve$MeanMin * 10 ^ 12) - input$Offset) / input$Cm
    CTcurve$MeanMaxCorrected <-
      ((CTcurve$MeanMax * 10 ^ 12) - input$Offset) / input$Cm
    CTcurve <<- CTcurve
    
    output$DF_CTcurve <-
      DT::renderDataTable(CTcurve,
                          options = list(
                            escape = F,
                            scrollX = T,
                            scrollY = 500
                          ))
    
  }, ignoreInit = T)
  
  observeEvent(input$Save_CSV, {
    fileinfo <- parseSavePath(volumes, input$Save_CSV)
    if (nrow(fileinfo) > 0) {
      try({
        write.csv(CTcurve, as.character(fileinfo$datapath), row.names = F)
        sendSweetAlert(
          session = session,
          title = "Success !",
          text = paste0("Saved: ", as.character(fileinfo$datapath)),
          type = "success"
        )
      })
    }
  }, ignoreInit = T)
  
  
  observeEvent(input$Save_R, {
    fileinfo <- parseSavePath(volumes, input$Save_R)
    if (nrow(fileinfo) > 0) {
      try({
        save(CTcurve, file = as.character(fileinfo$datapath))
        sendSweetAlert(
          session = session,
          title = "Success !",
          text = paste0("Saved: ", as.character(fileinfo$datapath)),
          type = "success"
        )
      })
    }
  }, ignoreInit = T)
  
  observeEvent(input$Import_CSV, {
    fileinfo <- parseFilePaths(volumes, input$Import_CSV)
    if (nrow(fileinfo) > 0) {
      try({
        CTcurve <- read_csv(as.character(fileinfo$datapath))
      })
    }
    CTcurve <<- CTcurve
    output$DF_CTcurve <-
      DT::renderDataTable(CTcurve,
                          options = list(
                            escape = F,
                            scrollX = T,
                            scrollY = 500
                          ))
  }, ignoreInit = T)
  
  observeEvent(input$Import_R, {
    fileinfo <- parseFilePaths(volumes, input$Import_R)
    if (nrow(fileinfo) > 0) {
      try({
        CTcurve <- load(as.character(fileinfo$datapath))
      })
    }
    CTcurve <<- CTcurve
  }, ignoreInit = T)
  
  observeEvent(input$ChangeWorkspace, {
    wddir <- jchoose.dir()
    if (length(wddir) > 0)
      setwd(wddir)
    volumes <<- c(Workspace = getwd(), Home = fs::path_home(), "R Installation" = R.home(), getVolumes()())
  })
  if (!interactive()) {
    session$onSessionEnded(function() {
      stopApp()
      q("no")
    })
    
  }
}



# Run the application
shinyApp(ui = ui, server = server)
