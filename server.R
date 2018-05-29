source(paste0(script.dirname,"/server/Analysis/RenderLoadFiles.R"))

server <- function(input, output,session) {
  ##### 
  #Provador
  ####
  provador=F
  if(provador){
    input <- list()
    newData <-  read_xlsx("~/Escritorio/Resultados_INT_44_2017.xlsx",col_names = TRUE,sheet = 1)
    functions <- read_xlsx("~/Escritorio/Resultados_INT_44_2017.xlsx",col_names = TRUE,sheet = 2)
    input$factors <- c("X__1","ID","PEN","trat","block","Teixit")
    input$covariables <- c("trat")
    input$Tissue <- c("Teixit")
    input$tissuecat <- c("Ili")
    input$NAInput <- 0.5
    }

  
  ######
  #
  # Leer los datos como primera acción
  #
  ######
  
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


  #####
  #
  # Leer las funciones de los genes
  #
  ####
  Functions <- reactive({
    inFile <- input$file1 
    if (is.null(inFile))
      return(NULL)
    if(file_ext(inFile$name)=="xlsx"){
      validate(
        need(file_ext(input$file1$name) %in% c(
          'xlsx'
        ), "Wrong File Format try again!"))
      table1 <- read_xlsx(inFile$datapath,col_names = TRUE,sheet = 2)
    }
  })
  
  ####
  #
  # Filtrar NA's, SELECTOR NA'S
  #
  ####
  
  output$NAs <- renderUI({
    validate(need(input$file1,"Insert File!"))
    div(p(paste0("Total rows: ",nrow(dt()))),
    p(paste0("Total columns: ", ncol(dt()))),
    p(paste0("Number of NA in database: ",sum(apply(dt(),1,function(x) sum(is.na(x)))))))
  })
  
  
  
  ####
  #
  # Selectores (Uno para los factores, uno para el subset, uno para la covariable); alfa slectors 
  #
  ####
  output$NAinput <- renderPrint({ input$NAinput })
  output$factorSelection<- renderUI({
    validate(need(input$file1,"Insert File!"))
    selectizeInput("factors","Select Factors:",
                 choices = c(colnames(dt())),selected=NULL, multiple = TRUE)})
  output$TissueSelection <- renderUI({
    validate(need(input$factors,"Select factors of dataset"))
    validate(need(input$covariables,"Select covariable of dataset"))
    selectizeInput("Tissue","Select Tissue variable:",choices = c(input$factors),selected=F, multiple = FALSE)})
  output$TissueCategory <- renderUI({
    datTiss<- dt()
    conditionalPanel(condition = "input.Tissue",
                     validate(need(input$factors,"Select Tissue")),
                     selectizeInput("tissuecat","Select Tissue's category:",choices = datTiss[[input$Tissue]],selected=F, multiple = FALSE))})
  output$covariableSelection<- renderUI({
    validate(need(input$factors,"Select factors of dataset"))
    selectizeInput("covariables","Select Treatment:",choices = c(input$factors),selected=F, multiple = FALSE)})
  output$alpha <- renderPrint({ input$alpha })
  
  
  
  ####
  #
  # Tabla global
  #
  ####
  newData <- eventReactive(input$Start,{
    dat <- dt()
    if(provador==T){dat <- newData}    
    bad.sample <- list()
    ##Bye bye NA's
    for(i in 1:length(levels(as.factor(unlist(dat[,input$covariables]))))){
      datCat <- subset(dat, dat[,input$covariables]==levels(as.factor(unlist(dat[,input$covariables])[i])))
      bad.sample[[i]]<- colMeans(is.na(datCat)) > input$NAInput
    }
    
    newData <- as.data.frame(dat[,!colnames(dat) %in% unique(names(which(unlist(bad.sample)==T)))])
    newData <- subset(newData, newData[,input$Tissue]==input$tissuecat)
    rownames(newData) <- paste("Sample", 1:nrow(newData),sep="")
    newData
  })
  
  dataExpression <- eventReactive(input$Start,{
    newDat <- newData()
    if(provador==T){newDat <- newData}
    newDataFact <- newDat[,input$factors]
    colnames(newDataFact) <- input$factors
    df <- data.frame(newDataFact[,input$covariables],
                   row.names=paste("Sample", 1:nrow(newDataFact), sep=""))
    colnames(df) <- as.character(input$covariables)
    idx <- match(input$factors, names(newDat))
    idx <- sort(c(idx-1, idx))
    nw <- log10(newDat[,-idx])
    #nw <- subset(newData, colnames(newData) %in% input$factors)
    Expression <- ExpressionSet(as.matrix(t(nw)),phenoData = AnnotatedDataFrame(data=df))
    Expression
    })

  #Load file function server
  output$table <-renderDataTable({dt()})
  output$table2 <- renderDataTable({Functions()})
  ####
  #
  # Tabla gene x samples
  #
  ####
  
  
  output$tableHead <- renderTable({
    validate(need(input$file1,"Insert File!"))
    validate(need(input$factors,"Select all factors of dataset"))
    validate(need(input$covariables,"Select covariable"))
    exprs(dataExpression())[1:6,1:6]
  },rownames=T)
  
  ####
  #
  # Tabla Ftests
  #
  ####
  significatius <- reactive({
    functions <- Functions()
    Express <- dataExpression() 
    if(provador==T){Express <- Expression}
    tt=rowFtests(Express,as.factor(pData(Express)[,input$covariables]))
    p.BH = p.adjust(tt[,"p.value"], "BH" )
    tt <- cbind(tt,p.BH)
    functions<- functions[functions$Gens %in% rownames(tt),]
    rownames(tt) <- paste0(functions$Funcions,"_",functions$Gens)
    tt
  })
  
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
  
  ####
  #
  # Tabla Tukey
  #
  ####
   output$tableTukey <- renderTable({
     a<- significatius()
     g <- which( a[,3] <= input$alpha)
     validate(need(g,"No hi ha cap valor significatiu"))
      Tukey_test<- function(dataExpression){
      Tuk <- list()
      for(i in 1:nrow(exprs(dataExpression))){
        if( sum(is.na(exprs(dataExpression)[i,])) < length(exprs(dataExpression)[i,])-2){
          Tuk[[i]] <- TukeyHSD(aov(exprs(dataExpression)[i,]~ as.factor(pData(dataExpression)[,1])))
          names(Tuk)[[i]] <- rownames(exprs(dataExpression))[i]
        }
      }
      return(na.omit(Tuk))
      }
    Tuk <- Tukey_test(dataExpression())
    tt <- significatius()
    names(Tuk) <- rownames(tt)
    dataTuk <- as.data.frame(na.omit(t(sapply(Tuk,function(x) x$`as.factor(pData(dataExpression)[, 1])`[,4], USE.NAMES = F))))
    dataTuk <- dataTuk[rowSums(dataTuk <= input$alpha)>=1,]
    dataTuk
    },rownames = T,digits=4)
    
  ######
  #
  # Tukey plots
  #
  #####
   
  
    
  ####
  #
  # LinePlots
  #
  #### 
  # 
  # Color picker
  #   
  ####  
  cols <- reactive({
    newDataCol <- newData()
    colins <- c("black","green","blue","red","yellow","orange","royalblue") 
   
      lapply(1:length(levels(as.factor(newDataCol[[input$covariables]]))), function(i) {
        div(style="display: inline-block;vertical-align:top; width: 150px;",colourpicker::colourInput(paste("col", i, sep="_"), paste0("Treatment",i), colins[i],returnName = TRUE, allowTransparent = TRUE))
    })
  })
  output$colorSelector <- renderUI({cols()})
  
  
  colors <- reactive({
    newDat <- newData()
    lapply(1:length(levels(as.factor(newDat[[input$covariables]]))), function(i) {
      input[[paste("col", i, sep="_")]]
    })
  })

  treat <- reactive({
    dat<- dt()
    selectizeInput("treatcat","Select treat category:",choices = dat[[input$covariables]],selected=T, multiple = FALSE)
    })

  output$treatSelector <- renderUI({treat()})
  
  output$lineplot <- renderPlot({
    validate(need(input$file1,"Insert File!"))
    validate(need(input$factors,"Select factors of dataset"))
    validate(need(input$covariables,"Select covariable of dataset"))
    newDat <- newData()
    functions <- Functions()
    if(provador==T){ newDat <- newData;input$defCol=1;input$orderLine=1}
    idx <- match(input$factors, names(newDat))
    idx <- sort(c(idx-1, idx))
    nw <- log10(newDat[,-idx])
    nw[[input$covariables]] <- newDat[,input$covariables]
    maxim <- list()
    minim <- list()
    for(i in 1:length(levels(as.factor(nw[,input$covariables])))){
      
      maxim[[i]] <- as.numeric(max(colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T)))
      minim[[i]] <- as.numeric(min(colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T)))

    }
    
    if(as.numeric(input$defCol) == 1 ) {
      colorins <- 1:length(levels(as.factor(newDat[[input$covariables]])))
     } else {
       colorins <- unlist(colors())
     }
    
    mitjanes <- list()
    if(as.numeric(input$orderLine)==1){
    for(i in 1:length(levels(as.factor(newDat[,input$covariables])))){
        mitjanes[[i]] <- colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T)
    }
    mitjanes <- as.data.frame(matrix(unlist(mitjanes),nrow=length(mitjanes[[1]]),byrow=F))
    colnames(mitjanes) <- levels(as.factor(newDat[,input$covariables]))
    rownames(mitjanes) <- colnames(nw)[-ncol(nw)]
    funcions<- functions[unlist(functions[,1]) %in% colnames(nw),]
    noms <- paste0(funcions$Funcions,"_",funcions$Gens)
    mitjanes<- cbind(noms,mitjanes)
    mitjanes <- mitjanes[order(mitjanes[,input$treatcat],decreasing = T),]
    nomsfinals <- mitjanes[,"noms"]
    mitjanes <- mitjanes[,-1]
    
    }else if(as.numeric(input$orderLine)==2){
      for(i in 1:length(levels(as.factor(newDat[,input$covariables])))){
        mitjanes[[i]] <- colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T)
      }
      mitjanes <- as.data.frame(matrix(unlist(mitjanes),nrow=length(mitjanes[[1]]),byrow=F))
      colnames(mitjanes) <- levels(as.factor(newDat[,input$covariables]))
      rownames(mitjanes) <- colnames(nw)[-ncol(nw)]
      funcions<- functions[unlist(functions[,1]) %in% colnames(nw),]
      noms <- paste0(funcions$Funcions,"_",funcions$Gens)
      mitjanes<- cbind(noms,mitjanes)
      mitjanes<-mitjanes[order(mitjanes[,"noms"]),]
      nomsfinals <- mitjanes[,"noms"]
      mitjanes <- mitjanes[,-1]
    }else{
      for(i in 1:length(levels(as.factor(newDat[,input$covariables])))){
        mitjanes[[i]] <- colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T)
      }
      mitjanes <- as.data.frame(matrix(unlist(mitjanes),nrow=length(mitjanes[[1]]),byrow=F))
      colnames(mitjanes) <- levels(as.factor(newDat[,input$covariables]))
      rownames(mitjanes) <- colnames(nw)[-ncol(nw)]
      funcions<- functions[unlist(functions[,1]) %in% colnames(nw),]
      noms <- paste0(funcions$Funcions,"_",funcions$Gens)
      mitjanes<- cbind(noms,funcions,mitjanes)
      mitjanes<-mitjanes[order(mitjanes[,"Funcions"],-mitjanes[,paste0(input$treatcat)]),]
      nomsfinals <- mitjanes[,1]
      mitjanes <- mitjanes[,-c(1:3)]
      }
    par(mar=c(14, 3, 1, 1))
    for(i in 1:length(levels(as.factor(newDat[,input$covariables])))){
      if(i == 1){
        plot(mitjanes[,i],col=colorins[i],ylim=c(min(as.numeric(na.omit(unlist(minim))))-0.1,max(as.numeric(na.omit(unlist(maxim))))+0.1),type="o",pch=19,xaxt='n',xlab=NA,ylab=NA)
        axis(1, at=1:(ncol(nw)-1), labels=nomsfinals,las=2, cex.axis=0.8)
      }else{
      lines(mitjanes[,i],col=colorins[i],type="o",pch=19)
    }
    }
    a<- significatius()
    g <- which( a[,3] <= input$alpha)
    validate(need(g,"No hi ha cap valor significatiu"))
    sign<- significatius()
    if(provador==T){sign <- tt}
    sign <- na.omit(sign)
    signAblines<- rownames(sign[sign$p.BH<=input$alpha,])
    signAblines<- which(nomsfinals %in% signAblines)
    for(i in 1:length(signAblines)) abline(v=signAblines[i],col="black",lty="dotted")
    legend("topright",paste0("T",1:length(levels(as.factor(newDat[,input$covariables])))), cex=0.8, col=colorins,lty=1, title=input$covariables)
       })
    # ####
    #
    # Heatmap
    #
    #### 
    
    output$heatmap <-renderPlotly({
        validate(need(input$file1,"Insert File!"))
        validate(need(input$factors,"Select factors of dataset"))
        validate(need(input$covariables,"Select covariable of dataset"))
        newDat <- newData()
        Covariable<- as.factor(pData(dataExpression())[,input$covariables])
        Covariable <- as.data.frame(Covariable)
        colnames(Covariable) <- input$covariables
        divergent_viridis_magma <- c(viridis(10, begin = 0.3), rev(magma(10, begin = 0.3)))
        rwb <- colorRampPalette(colors = c("darkred", "white", "darkgreen"))
        BrBG <- colorRampPalette(brewer.pal(11, "BrBG"))
        Spectral <- colorRampPalette(rev(brewer.pal(40, "Spectral")))
        heatmaply(exprs(dataExpression()),colors=Spectral,na.value = "grey50",na.rm=F,ColSideColors=Covariable,margins = c(120,120,20,120),seriate = "OLO")
        
      })
    
    ####
    #
    # Components principals
    #
    #### 
    output$pca <- renderPlot({
      validate(need(input$file1,"Insert File!"))
      validate(need(input$factors,"Select factors of dataset"))
      validate(need(input$covariables,"Select covariable of dataset"))
      newDat <- newData()
      functions <- Functions()
      if(provador==T){ newDat <- newData;input$defCol=1;input$orderLine=1}
      idx <- match(input$factors, names(newDat))
      idx <- sort(c(idx-1, idx))
      nw <- log10(newDat[,-idx])
      nw[[input$covariables]] <- newDat[,input$covariables]
      mitjanes <- list()
      for(i in 1:length(levels(as.factor(newDat[,input$covariables])))){
          mitjanes[[i]] <- colMeans(subset(nw,nw[[input$covariables]]==i)[,-ncol(nw)],na.rm = T)
      }
      mitjanes <- as.data.frame(matrix(unlist(mitjanes),nrow=length(mitjanes[[1]]),byrow=F))
      colnames(mitjanes) <- levels(as.factor(newDat[,input$covariables]))
      rownames(mitjanes) <- colnames(nw)[-ncol(nw)]
      funcions<- functions[unlist(functions[,1]) %in% colnames(nw),2]
      mitjanes<- cbind(funcions,mitjanes)
      
      pcajetr<-PCA(mitjanes,quali.sup=1,graph=F)
      par(mfrow = c(1,2),
          oma = c(0,0,0,0) + 0.5,
          mar = c(4,4,4,4) + 0.5)
      plot(pcajetr,choix="var",col.var="blue",cex.main=0.7)
      plot(pcajetr,choix="ind",habillage=1,label="quali",cex.main=0.7)
        
    })
  ####
  #
  # Codi per tancar automaticament l'aplicacio web
  #
  ####
  
  # output$markdown <- renderUI({
  #   HTML(markdown::markdownToHTML(paste0(script.dirname,'Usage.md')))
  # })
  
  
  session$onSessionEnded(function() {
    stopApp()
  })
}