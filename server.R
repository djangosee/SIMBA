source(paste0(script.dirname,"/server/Analysis/RenderLoadFiles.R"))

server <- function(input, output,session) {
  
  dt <- reactive({
  inFile <- input$file1 
  if (is.null(inFile))
    return(NULL)
  if(file_ext(inFile$name)=="csv"){
    validate(
      need(file_ext(input$file1$name) %in% c(
        'csv'
      ), "Wrong File Format try again!"))
  table1 <- read.csv2(inFile$datapath,header = T,sep = ",")
  return(table1)
  }else{
    validate(
      need(file_ext(input$file1$name) %in% c(
        'xlsx'
      ), "Wrong File Format try again!"))
  table1 <- read_xlsx(inFile$datapath,col_names = TRUE,sheet = 1)
  }
  })

  
  output$factorSelection<- renderUI({selectizeInput("factors","Select factors:",
                 choices = c(colnames(dt())),selected=NULL, multiple = TRUE)})
  output$covariableSelection<- renderUI({selectizeInput("covariables","Select covariable:",
                                                    choices = c(input$factors),selected=NULL, multiple = FALSE)})
  output$alpha <- renderPrint({ input$alpha })
  
  
  dataExpression <- reactive({
    dat <- dt()
    bad.sample <- colMeans(is.na(dat)) > 0.8
    bad.gene <- rowMeans(is.na(dat)) > 0.5
    newData <- as.data.frame(dat[!bad.gene,!bad.sample])
    rownames(newData) <- paste("Sample", 1:nrow(newData),sep="")
    
    newDataFact <- newData[,input$factors]
    colnames(newDataFact) <- input$factors
    df <- data.frame(newDataFact[,input$covariables],
                   row.names=paste("Sample", 1:nrow(newDataFact), sep=""))
    
    colnames(df) <- as.character(input$covariables)
    idx <- match(input$factors, names(newData))
    idx <- sort(c(idx-1, idx))
    nw <- log10(newData[,-idx])   
    #nw <- subset(newData, colnames(newData) %in% input$factors)
    Expression <- ExpressionSet(as.matrix(t(nw)),phenoData = AnnotatedDataFrame(data=df))
    Expression
    })
  
  #genes_names <- reactive({colnames(newData())})

  #Load file function server
  output$table <-renderTable({dt()})
  
  output$tableHead <- renderTable({
    validate(need(input$file1,"Insert File!"))
    validate(need(input$factors,"Select all factors of dataset"))
    validate(need(input$covariables,"Select covariable"))
    head(exprs(dataExpression()),n=6)
  },rownames=T)
  
  output$tableMCA<- renderTable({
    validate(need(input$file1,"Insert File!"))
    validate(need(input$factors,"Select all factors of dataset"))
    validate(need(input$covariables,"Select covariable"))
    tt=rowFtests(dataExpression(),as.factor(pData(dataExpression())[,input$covariables]))
    p.BH = p.adjust(tt[,"p.value"], "BH" )
    tt <- cbind(tt,p.BH)
    rownames(tt) <- rownames(exprs(dataExpression()))
    tt$p.value <- format(tt$p.value,4)
    tt$p.BH <- format(tt$p.BH,4)
    g <- which( tt[,2] <= input$alpha)
    if( length(g) > 0){
      pvaluesTable<- data.frame(tt[g,])
      colnames(pvaluesTable) <- c("Contrast Statistic", "P-value", "P-value Benjamini-Hochberg (FDR)")
      rownames(pvaluesTable) <- rownames(tt[g,])
      aligned <- 'rrr'
      pvaluesTable
    }else{
      aligned=NULL
      print("No hi ha cap significatiu")
    }
    
  },rownames=T)
  
  observeEvent(input$button,{
    output$heatmap <-renderPlotly({
    validate(need(input$file1,"Insert File!"))
    validate(need(input$factors,"Select factors of dataset"))
    validate(need(input$covariables,"Select covariable of dataset"))
    Covariable<- as.factor(pData(dataExpression())[,input$covariables])
    Covariable <- as.data.frame(Covariable)
    colnames(Covariable) <- input$covariables
    heatmaply(exprs(dataExpression()),na.value = "grey50",na.rm=F,ColSideColors=Covariable,margins = c(120,120,20,120),seriate = "OLO")
    
    })
  })
  
  observeEvent(input$button,{
  output$lineplot <- renderPlot({
    validate(need(input$file1,"Insert File!"))
    validate(need(input$factors,"Select factors of dataset"))
    validate(need(input$covariables,"Select covariable of dataset"))
    dat <- dt()
    bad.sample <- colMeans(is.na(dat)) > 0.8
    bad.gene <- rowMeans(is.na(dat)) > 0.5
    newData <- as.data.frame(dat[!bad.gene,!bad.sample])
    rownames(newData) <- paste("Sample", 1:nrow(newData),sep="")
    idx <- match(input$factors, names(newData))
    idx <- sort(c(idx-1, idx))
    nw <- log10(newData[,-idx])
    nw[[input$covariables]] <- newData[,input$covariables]
    maxim <- list()
    minim <- list()
    for(i in 1:length(levels(as.factor(nw[,input$covariables])))){
      
      maxim[[i]] <- as.numeric(max(colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T)))
      minim[[i]] <- as.numeric(min(colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T)))

    }
    
    for(i in 1:length(levels(as.factor(newData[,input$covariables])))){
      if(i == 1){
        plot(colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T),ylim=c(min(as.numeric(na.omit(unlist(minim))))-0.1,max(as.numeric(na.omit(unlist(maxim))))+0.1),type="o",pch=19,col=i,xaxt='n',xlab=NA,ylab=NA)
        axis(1, at=1:(ncol(nw)-1), labels=colnames(nw)[-ncol(nw)],las=2, cex.axis=0.8)
      }else{
      lines(colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T),col=i,type="o",pch=19)
    }
    }
    legend("topright",paste0("T",1:length(levels(as.factor(newData[,input$covariables])))), cex=0.8, col=1:length(levels(as.factor(newData[,input$covariables]))),lty=1, title=input$covariables)
    
  })})

  
  
  #Codi per tancar automaticament l'aplicacio web
  session$onSessionEnded(function() {
    stopApp()
  })
}