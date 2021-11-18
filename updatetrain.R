#install.packages("shiny",repos='http://cran.us.r-project.org')
#install.packages("DT",repos='http://cran.us.r-project.org')
library(shiny)

args <- commandArgs( trailingOnly = TRUE )
portnumber  <- 2021
if( length( args ) >= 1 )
  {
  portnumber  <- as.numeric( args[1] )
  }

# @egates1 - best practices for scope ?
# load data outside server so it is added to global environment
# and not loaded with every session connection
# https://shiny.rstudio.com/articles/scoping.html
csv.data <- read.csv("nashvisceral/wide.csv", header = TRUE,na.strings="")

qadatafiles=paste0("Processed/",csv.data$mrn,"/reviewsolution.txt")
qadatainfo <- rep(NA,length(qadatafiles))
for (iii in 1:length(qadatafiles))
{
 if(file.exists(qadatafiles[iii]))
 {
  qadatainfo[iii]<- paste(readLines(qadatafiles[iii]), collapse=" ")
 }
}


# set up reactive data for updating reviewed status
# "FixedNumber","PatientNumber","studynumber"
my.data <- reactiveValues(data=cbind(REVIEWED = F, csv.data,
  QA = qadatainfo,
visceraltrain=paste0("nashvisceral/",csv.data$mrn,"/train.nii.gz"),
visceraltrainExists=file.exists(paste0("nashvisceral/",csv.data$mrn,"/train.nii.gz")) 
))

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  titlePanel("Training Data"),
  # Create a save button
  actionButton("savereview","update table "),
  # Create a new row for the table.
  DT::dataTableOutput("table")
)


# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable(
    my.data$data,
    selection = "single"
  ))

  # system call selection for QA
  observeEvent(input$table_rows_selected, {
      system(paste0('echo ',my.data$data$mrn[input$table_rows_selected],';make Processed/',my.data$data$mrn[input$table_rows_selected],'/generatetrain '),wait = F)
   })
  
  observeEvent(input$savereview, {
    if( !is.null(input$table_rows_selected ) ) {
        current.row = input$table_rows_selected
        my.data$data$REVIEWED[current.row] = TRUE
        DT::reloadData(DT::dataTableProxy('table'), clearSelection = 'all' )
      }
    # select the next row in the table to open next case
    #DT::selectRows(DT::dataTableProxy('table'), min(current.row + 1, nrow(my.data$data)))
    # TODO: set displayed page correctly on save reviewd
  })
  
}

# Create Shiny app ----
app = shinyApp(ui = ui, server = server)
runApp(app,host="127.0.0.1", port=portnumber, launch.browser = FALSE)
# Rscript updatetrain.R 2025
# source("updatetrain.R")
