library(shiny)
library(caret)

data(airquality)

airquality <- airquality[!is.na(airquality$Ozone),];
airquality <- airquality[!is.na(airquality$Solar.R),];
model <- train(Ozone ~ ., data = airquality, method="lm");

shinyServer(
    function(input, output){
        output$airquality <- renderDataTable(airquality, options = list(
            pageLength = 5,
            lengthMenu = list(c(5, 10, 15, -1), c('5', '10', '15', 'All'))
        ));
        
        output$summaryModel <- renderPrint({summary(model)});
        
        inputDataFrame <- reactive({
            data.frame(
                Solar.R = c(input$solar.r), 
                Wind = c(input$wind), 
                Temp = c(input$temp),
                Month = c(as.numeric(format(input$date, format="%m"))),
                Day = c(as.numeric(format(input$date, format="%d")))
            )
        });
        
        prediction <- reactive({
            predict(model, inputDataFrame());
        });
        output$inputData <- renderTable({
            inputDataFrame()
        }, include.rownames=FALSE);
        
        output$predOzone <- renderText({
            paste0(round(prediction(), 2), " parts per billion")
        });
        
        
        output$histPlot <- renderPlot({
            ggplot(airquality, aes(x = Ozone)) + 
                geom_histogram(binwidth = 5, aes(fill=..count..)) + 
                #scale_fill_gradient("Count", low="blue", high="lightblue") + 
                geom_vline(xintercept = prediction(), color="red", size=1.5) 
        });
        
    }    
);