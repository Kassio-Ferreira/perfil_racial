#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(skin = "green",
  
  # Application title
  # titlePanel("Dados Abertos UFERSA"),
  # 
  # # Sidebar with a slider input for number of bins 
  # sidebarLayout(
  #   sidebarPanel(
  #     selectInput("ano", "Ano:", c(2014:2018))
  #   ),
  #   
  #   # Show a plot of the generated distribution
  #   mainPanel(
  #     plotlyOutput("ingressantes"),
  #     plotlyOutput("escolas"),
  #     plotlyOutput("classes")
  #   )
  # )
  
  dashboardHeader(title = "Dados Abertos - Perfil dos Alunos da UFERSA por raça",
                  titleWidth = 450),
  
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(fluidRow(
      
      box(selectInput("ano", "Ano:", c(2014:2018)),
          selectInput("periodo", "Periodo:", c(1:2)),
          checkboxGroupInput("raca", "Raça:",
                             c("Amarelo" = "Amarelo", "Branco" = "Branco", "Indígena" = "Indígeno",
                               "Não Informado" = "Não Informado", "Não Declarado" = "Não quero declarar",
                               "Outras" = "OUTRAS", "Pardo" = "Pardo"), selected = c("Não Declarado", "Outras",
                                                                                     "Não Informado"))
          ),
      box(plotlyOutput("ingressantes")),
      box(plotlyOutput("escolas")),
      box(plotlyOutput("classes")),
      box(DT::dataTableOutput('displayDf', width = "100%"), width = 12, align = "center")
      
    )
  )
  
  
))
