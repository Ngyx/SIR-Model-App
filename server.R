library(shiny)
library(deSolve)

#Define function
sir.model.closed <- function (t, x, params) {    
    S <- x[1]                               
    I <- x[2]
    R <- x[3]
    N <- S + I + R
    
    I[I<0]=0
    
    with(                                   
        as.list(params),                   
        { 
            dS = -beta*S*I/N
            dI = beta*S*I/N - gamma*I
            dR = gamma*I
            dx <- c(dS,dI,dR)                
            list(dx)                         
        }
    )
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    out = reactive({
        R = input$R_input
        I0 = input$I0_input
        S0 = 10000 - I0
        R0 = 0
        time_of_intervention = input$time_of_intervention_input
        intervention = 1-input$intervention_input
        
        gamma_day = input$gamma_day_input
        gamma = 1/gamma_day 
        beta = gamma*R
        beta_intervention = intervention * beta
        xstart = c(S=S0,I=I0,R=R0)
        params=c(beta=beta,gamma=gamma)
        
        times = seq(0,time_of_intervention,by=1)
        
        out1 = as.data.frame(ode(xstart,times,sir.model.closed,params)) 
        
        xstart = c(S=out1$S[time_of_intervention+1],I=out1$I[time_of_intervention+1],R=out1$R[time_of_intervention+1])
        params = c(beta=beta_intervention,gamma=gamma)
        times =  seq(time_of_intervention+1,200,by=1)
        out2 = as.data.frame(ode(xstart,times,sir.model.closed,params))  #result stored in dataframe
        
        out = rbind(out1,out2[-1,])
        out
    })
    
    output$Plot <- renderPlot({
        plot(out()$I,xlim=c(0,200),ylim=c(0,10000),type='l',lwd=2,ylab='Number',xlab='Days',
             col='red',main=paste('Daily no. of infected, susceptible and recovered individuals, R0 =',input$R_input))
        abline(v=input$time_of_intervention_input+1,col='black',lwd=2,lty=2)
        lines(out()$S,col='blue',lwd=2)
        lines(out()$R,col='green',lwd=2)
        if (input$show_legend) {legend("topright",col=c('red','blue','green'),legend=c("Infected","Susceptible","Recovered"),lty=1)}
    })
    
    output$MaxInfections = renderText({paste0("Max no. of daily infections: ",round(max(out()$I)))})
    output$Total = renderText({paste0("Total number of infections at end: ", round(out()$R[200]))})

})
