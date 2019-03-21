#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ckanr)
library(tidyverse)
library(plotly)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  url <- 'http://dadosabertos.ufersa.edu.br/'
  data = ds_search(resource_id = 'aecb1bb9-a846-4401-857d-b7f533f0d087', url = url, as = "table")
  
  data = as.data.frame(data$records)
  names(data) = iconv(names(data),from="UTF-8",to="ASCII//TRANSLIT")
  
  cols = 2:ncol(data)    
  data[,cols] = apply(data[,cols], 2, function(x) as.numeric(as.character(x)))
  
  filtra_ano_periodo <- function(data, ano, periodo, raca) dplyr::tbl_df(data) %>% 
    filter(., Ano == ano, Periodo == periodo, Raca %in% raca) 
  
  make_plot_ingressantes <- function(data, ano, periodo, raca){
    dados = filtra_ano_periodo(data, ano, periodo, raca)
    p <- plot_ly(dados, x = ~Raca, y = ~Ingressantes, type = 'bar', name = 'Quantidade') %>% 
      layout(title="Total de ingressantes")
    p
  }
  
  make_plot_escolas <- function(data, ano, periodo, raca){
    dados = filtra_ano_periodo(data, ano, periodo, raca)
    p <- plot_ly(dados, x = ~Raca, y = ~`Rede Privada`, type = 'bar', name = 'Rede privada') %>%
      add_trace(y = ~`Rede Publica`, name = 'Rede publica') %>%
      layout(yaxis = list(title = 'Quantidade'), barmode = 'group', title="Rede de ensino") 
    p
  }
  
  make_plot_classe <- function(data, ano, periodo, raca){
    dados = filtra_ano_periodo(data, ano, periodo, raca)
    p <- plot_ly(dados, x = ~Raca, y = ~`Classe A`, type = 'bar', name = 'Classe A') %>%
      add_trace(y = ~`Classe B`, name = 'Classe B') %>%
      add_trace(y = ~`Classe C`, name = 'Classe C') %>%
      add_trace(y = ~`Classe D`, name = 'Classe D') %>%
      add_trace(y = ~`Classe E`, name = 'Classe E') %>%
      layout(yaxis = list(title = 'Quantidade'), barmode = 'group', title="Classe social") 
    p
  }
  
   
  output$ingressantes <- renderPlotly({
    make_plot_ingressantes(data, input$ano, input$periodo, input$raca)
  })
  
  output$escolas <- renderPlotly({
    make_plot_escolas(data, input$ano, input$periodo, input$raca)
  })
  
  output$classes <- renderPlotly({
    make_plot_classe(data, input$ano, input$periodo, input$raca)
  })
  
  output$displayDf <- renderDT(
    filtra_ano_periodo(data, input$ano, input$periodo, input$raca), options = list(
      pageLength = 5)
    )
  
  
})
