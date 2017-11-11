source("EnaShiny_test3.R")

library(enaR)
library(shiny)
library(networkD3)

server <- function(input, output) {

############ File inputs 
  
  df_flow <- reactive({
    req(input$file1)
    read.csv(input$file1$datapath, row.names = 1)
    })
  
  df_input <- reactive({
    req(input$file2)
    read.csv(input$file2$datapath)})
  
  df_respiration <- reactive({
    req(input$file3)
    read.csv(input$file3$datapath)})
  
  df_export <- reactive({
    req(input$file4)
    read.csv(input$file4$datapath)})
  
  df_living <- reactive({
    req(input$file5)
    read.csv(input$file5$datapath)})
  
  df_storage <- reactive({
    req(input$file6)
    read.csv(input$file6$datapath)})
                            
  
############ Table outputs
  output$tb <- renderUI({
    
    output$table1 <- renderTable({df_flow()})
    output$table2 <- renderTable({df_input()})
    output$table3 <- renderTable({df_respiration()})
    output$table4 <- renderTable({df_export()})
    output$table5 <- renderTable({df_living()})
    output$table6 <- renderTable({df_storage()})
    
    tabsetPanel(tabPanel("Data Flow", tableOutput("table1")),
                tabPanel("Data Inputs", tableOutput("table2")),
                tabPanel("Data Respiration", tableOutput("table3")),
                tabPanel("Data Exports", tableOutput("table4")),
                tabPanel("Data Living", tableOutput("table5")),
                tabPanel("Data Storage", tableOutput("table6")))
  })

############ EnaR Indicator 
  
  output$main_outputs<-renderTable({
    Ena_mainOutputs_function (flow=df_flow(), input=df_input(), 
                              export=df_export(), respiration=df_respiration(), 
                              storage=df_storage(), living=df_living())
  })
  
############ EnaR plot Network 
  
  output$plot_network<-renderForceNetwork({
  
  Ena_inputs_function (flow=df_flow(), input=df_input(), 
                       export=df_export(), respiration=df_respiration(), 
                       storage=df_storage(), living=df_living())
  })
  
}

