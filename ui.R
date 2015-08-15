library(shiny)
shinyUI(
    pageWithSidebar(
        headerPanel("Developing Data Products - Project Page"),
        sidebarPanel(
            h3("Data of your place"),
            p("Please fill the following fields with the air attributes of your place."),
            
            numericInput('solar.r', 'Solar radiation (in Langleys):', 
                        min = 0.0, max = 350.00, value = 180.00, step = 0.1),
            
            sliderInput('wind', 'Average wind speed (mph):', 
                        min = 0.0, max = 25.00, value = 10.00, step = 0.5),
            
            sliderInput('temp', 'Maximum daily temperature (Fº):', 
                        min = 50.0, max = 100.00, value = 75.00, step = 0.2),
            
            dateInput('date', 'Date:')
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Getting started",
                    h3('What is this?'),
                    p('This is a web application that shows our prediction model working on real data. 
                      You only have to provide the application some values of the properties of the air 
                      in your place and it will compute automatically the quality of it.'),
                    h3('How do I use it?'),
                    p('The side panel shadowed in light gray allows you to enter the required values. 
                      For simplicity it already has some common values, so you may only need to change some of them. 
                      There is not need to press any Submit button after you changed the values, the prediction updates automatically when it detects a change in the input values.'),
                    p('Results of the prediction function can be seen in the "Prediction" tab. This section shows you which values have been used to compute the final result.'),
                    p('Finally in the "Documentation" tab you can find more technical information about the Domain of the application and the construction of the prediction model.'),
                    h3('What\'s next?'),
                    p('We hope you have a nice time using this application. Give it a try! Go to the Prediction tab and change some values in the Side panel.')
                ),
                tabPanel("Prediction",
                    p('From the data you provided we will try to predict the ozone 
                      (Mean ozone in parts per billion) in your place.'),
                    h5('Your entered data:'), 
                    tableOutput("inputData"), 
                    h5('Our prediction:'), 
                    p(
                        span('Using our prediction model for airquality data, your place has a mean ozone of: '),
                        h4(textOutput("predOzone", inline = TRUE))
                    ),
                    plotOutput("histPlot"),
                    p('Plot showing the current prediction (red line) in relation to all the samples of the airquality data set.')
                ),
                tabPanel("Documentation", 
                    h3('Domain'),
                    p('We want to predict the air quality of your place from the values of the Solar Radiation, Wind speed, Temperature and the date of the year.
                      The result of our prediction is a quantity representing the average amount of Ozone parts per billion.'),
                    p('For building our prediction system we used the airquality data set in R. Here you can inspect its values once we cleaned it up for training the model'),
                    pre('data(airquality)'),
                    dataTableOutput("airquality"),
                    
                    h3('Model'),
                    p('The amount of Ozone is a continuous value and, thus, we modelled a regression model using the cared package:'), 
                    pre('library(caret)'),
                    
                    p('We trained our model using the following command of the library: '),
                    pre('model <- train(Ozone ~ ., data = airquality, method="lm")'),
                    p('Resulting in a model with the following properties: '),
                    verbatimTextOutput('summaryModel')
                    
                )
            )            
        )
    )
);