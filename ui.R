#Check and install missing packages
list.of.packages <- c("shiny", "enaR", "networkD3")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(shiny)
library(networkD3)

ui <- fluidPage(
  
  titlePanel("Shiny App for EnaR"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Input: Select a file
      fileInput("file1", "Choose flow CSV File"),
      fileInput("file2", "Choose input CSV File"),
      fileInput("file3", "Choose respiration CSV File"),
      fileInput("file4", "Choose export CSV File"),
      fileInput("file5", "Choose living CSV File"),
      fileInput("file6", "Choose storage CSV File")
    ),
    
    mainPanel(
      
      uiOutput("tb"),
      tableOutput("main_outputs"),
      forceNetworkOutput("plot_network")
      
    )
  )
)

