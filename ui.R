library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Simulating spread of infectious disease and effects of interventions
               in a population of 10,000"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("R_input","Reproduction number:",
                        min = 1,max = 10,value = 3),
            sliderInput("I0_input","Initial number of infections:",
                        min=1,max=500,value=5),
            sliderInput("gamma_day_input","Number of days to recovery after infection:",
                        min=1,max=10,value=5),
            sliderInput("time_of_intervention_input","Time of intervention (days):",
                        min=1,max=100,value=20),
            sliderInput("intervention_input","Reduction in spread after intervention",
                        min=0.0,max=1.0,value=0.5),
            checkboxInput("show_legend", "Show/hide legend", value = TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("Plot"),
            textOutput("MaxInfections"),
            textOutput("Total")
        )
    )
))
