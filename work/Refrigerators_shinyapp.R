# Read libraries
library(shiny)
library(data.table)
library(shinyjs)
library(dplyr)
# library(readr) # for tsv

# Load workfile
dataset <- data.table(read.table("dt_refrigerator_workfile.txt", sep = "|", header = T))


# Set variable type
dataset$common_item_id <- dataset$common_item_id %>% as.numeric()
dataset$common_item_name <- dataset$common_item_name %>% as.character()
dataset$item_name_short <- dataset$item_name_short %>% as.character()
dataset$colour <- dataset$colour %>% as.character()
dataset$producer <- dataset$producer %>% as.character()

dataset$type <- dataset$type %>% as.character()
dataset$energy_class <- dataset$energy_class %>% as.character()
dataset$energy_consumption <- dataset$energy_consumption %>% as.numeric()
dataset$guarantee_month <- dataset$guarantee_month %>% as.numeric()
dataset$width_cm <- dataset$width_cm %>% as.numeric()

dataset$website <- dataset$website %>% as.character()
dataset$link <- dataset$link %>% as.character()

#############################################
# User Interface
#############################################

appCSS <- "
#loading-content {
position: absolute;
background: #FFFFFF;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #000000;
}
"

ui <- fluidPage(
  
  useShinyjs(),
  inlineCSS(appCSS),
  
  # Loading message
  div(
    id = "loading-content",
    h2("Loading...")
  ),
  
  ## title of the app
  #headerPanel("Bee or not to bee"),
  titlePanel("Compare refrigerators"),
  
  h3("Compare all the refrigerators of Mediamark and Edigital"),
  h5("Same products have been merged having the same common_item_id and common_item_name. One product can be listed many times,
    if more items occured with the same attributes on mediamarkt.hu and edigital.hu.
     Columns:
     energy_class: based on the European Union energy label, energy_consumption: expressed in kWh per year, 
     guarantee_month: producer's guarantee expressed in month, total_capacity: cooling and frozing capacity altogether in litre,
     width_cm: width of the product in cm, height_cm: height of the product in cm, depth_cm: depth of the product in cm,
     n_doors: number of doors on the product, weight_kg: weight of the product in kg, website: on which the given item can be found,
     item_price: offered price in Ft on the given website, link: hyperlink to the given item"),
  
  br(),
  
  # The main app code goes here
  hidden(
    div(
      id = "app-content",
      p(
        
        #inputs  
        fluidRow(
          column(width=3,
                 selectInput(inputId = "type",
                             label = "Type",
                             choices = sort(c(as.character(unique(dataset$type)))),
                             selected = "Refrigerator")),
          
          column(width=3,
                 selectInput(inputId = "producer",
                             label = "Producer",
                             choices = sort(c(as.character(unique(dataset$producer)))),
                             selected = "AEG")),
          
          column(width=3,
                 sliderInput(inputId ="total_capacity", 
                             label = "Min total capacity (l)", 
                             value=200, min=0, max=800, step =20)),
          
          column(width=3,
                 sliderInput(inputId ="item_price", 
                             label = "Max price (Ft)", 
                             value=150000, min=0, max=800000, step =10000))
          
        ),
        
        
        tags$hr(),
        
        #outputs
        tableOutput(outputId = "table"),
        
        br(),
        
        tags$hr(),
        
        br(),
        br()
        
      )
    )
  )
)



#############################################
# Back end
#############################################

server <- function(input,output){
  
  # Simulate work being done for 0.5 second
  Sys.sleep(0.5)
  
  # Hide the loading message when the rest of the server function has executed
  hide(id = "loading-content", anim = TRUE, animType = "fade")    
  show("app-content")
  
  szures<-reactive({
    
    dataset[type == input$type & 
              producer == input$producer &
              total_capacity >= input$total_capacity &
              item_price <= input$item_price, c("common_item_id",
                                                "common_item_name",
                                                "colour",
                                                "energy_class",
                                                "energy_consumption",
                                                "guarantee_month",
                                                "total_capacity",
                                                "width_cm",
                                                "height_cm",
                                                "depth_cm",
                                                "n_doors",
                                                "weight_kg",
                                                "website",
                                                "item_price",
                                                "link")]
    
  })
  
  
  
  output$table <- renderTable({szures()}, 
                              # options = list(lengthChange = FALSE, orderClasses = TRUE),
                              # spacing = 'm',
                              digits = 0
                              # rownames = TRUE,
                              # align = 'clrc'
  )
}

## start the Shiny app
shinyApp(ui = ui, server = server)
