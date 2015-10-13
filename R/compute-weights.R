# For "Compute Weights" Dialogue
# Test: Spawns a dialogue
# If population size estimate is empty, "please enter the estimate population size" pops up
###############################################################################


.makeComputeWeightsDialog <- function(showRDS1=TRUE){
	
	JSeparator <- J("javax.swing.JSeparator")
	Deducer <- J("org.rosuda.deducer.Deducer")
	RActionListener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(400L,300L)
	dialog$setTitle("Compute Weights")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystComputeWeights")
	
	obj <- new(Deducer::ObjectChooserWidget,"RDS Data",dialog)
	obj$setClassFilter("rds.data.frame")
	addComponent(dialog, obj, 20, 450, 180, 20)
	
	sep <- new(JSeparator)
	addComponent(dialog, sep, 230, 980, 180, 20,bottomType="NONE")
	
	type <- new(Deducer::ButtonGroupWidget,"Type",c("Gile's SS","RDS-I","RDS-I (DS)","RDS-II"))
	addComponent(dialog, type, 300, 450, 800, 20)
	
	var <- new(Deducer::TextFieldWidget,"New Variable")
	var$setDefaultModel("weights")
	addComponent(dialog, var, 20, 980, 180, 500)
	
	pop <- new(Deducer::TextFieldWidget,"Population Size Estimate")
	pop$setInteger(TRUE)
	pop$setLowerBound(1)
	addComponent(dialog, pop, 280, 980, 440, 500)
	
	ss <- new(Deducer::TextFieldWidget,"# of Samples Per Iteration")
	ss$setInteger(TRUE)
	ss$setLowerBound(1)
	ss$setDefaultModel("1000")
	addComponent(dialog, ss, 450, 980, 610, 500)
	
	gv <- new(Deducer::TextFieldWidget,"Group Variable")
	gv$setDefaultModel("")
	addComponent(dialog, gv, 450, 980, 610, 500)
	gv$setVisible(FALSE)
	
	typeListener <- new(RActionListener)
	typeListener$setFunction(toJava(function(cmd,ActionEvent){
				if(cmd=="Gile's SS"){
					ss$setVisible(TRUE)
				}else{
					ss$setVisible(FALSE)
				}
				if(cmd %in% c("RDS-I","RDS-I (DS)")){
					gv$setVisible(TRUE)
				}else{
					gv$setVisible(FALSE)
				}
			}))
	type$addListener(typeListener)
	checkFunc <- function(x){
		if(is.null(obj$getModel())) 
			"No RDS data set loaded"
		else if(var$getModel()=="") 
			"Please enter a variable name"
		else {
			data <- eval(parse(text=obj$getModel()))
			NEst <- attr(data,"population.size.mid")
			if(!is.null(NEst)) 
				pop$setModel(as.character(NEst))
			if(pop$getModel()=="" && type$getModel()=="Gile's SS") 
				"Gile's SS estimator requires a population size"
			else if(ss$getModel()=="") 
				"Please enter the number of simulated samples per iteration"
			else if(type$getModel()=="RDS-I" & gv$getModel()=="") 
				"Please enter a group variable for the RDS-I weights"
			else if(type$getModel()=="RDS-I (DS)" & gv$getModel()=="") 
				"Please enter a group variable for the RDS-I (DS) weights"
			else 
				''
		}
	}
	dialog$setCheckFunction(toJava(checkFunc))
	
	runFunc <- function(x){
		varName <- Deducer$makeValidVariableName(var$getModel())
		'%+%' <- function(x,y) paste(x,y,sep="") 
		data <- obj$getModel()
		cmd <- data %+% "$" %+% varName %+% " <- compute.weights(" %+% data %+%
				", weight.type=\"" %+% type$getModel() %+% "\", N=" %+% pop$getModel() %+%
				", outcome.variable=\"" %+% gv$getModel() %+%
				"\", number.ss.samples.per.iteration=" %+% pop$getModel() %+%")"
		cmd <- cmd %+% "\n"
		cmd <- cmd %+% "attr(" %+% data %+% ",'design')=svydesign(ids=" %+% data %+% "[[attr(" %+% data %+% ",'id')]]"
		cmd <- cmd %+% ", weights=" %+% data %+% "$" %+% varName
		cmd <- cmd %+% ",fpc=rep(attr(" %+% data %+% ",'population.size.mid'),nrow(" %+% data %+% "))"
		cmd <- cmd %+% ",data=" %+% data %+% ")" 
		execute(cmd)
	}
	dialog$setRunFunction(toJava(runFunc))
	dialog
}

.makeComputeWeightsPanel <- function(dialog,variableSelector,variableList=NULL,showRDS1=TRUE ){
	
	JPanel <- J("javax.swing.JPanel")
	Dimension <- J("java.awt.Dimension")
	AnchorLayout <- J("org.rosuda.JGR.layout.AnchorLayout")
	RActionListener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	
	lastData <- ""
	
	panel <- new(JPanel)
	panel$setPreferredSize(new(Dimension,75L,100L))
	panel$setSize(new(Dimension,75L,100L))
	panel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Weights"))
	panel$setLayout(new(AnchorLayout))
	
	
	if(showRDS1)
		type <- new(Deducer::ButtonGroupWidget,c("Gile's SS","RDS-I","RDS-I (DS)","RDS-II","Arithmetic Mean"))
	else
		type <- new(Deducer::ButtonGroupWidget,c("Gile's SS","RDS-II","Arithmetic Mean"))
	addComponent(panel, type, 165, 950, 300, 50,bottomType="ABS",topType="ABS")
	dialog$track(type)
	
	ss <- new(Deducer::TextFieldWidget,"# Sim. / Iter.")
	ss$setInteger(TRUE)
	ss$setLowerBound(1)
	ss$setDefaultModel("1000")
	addComponent(panel, ss, 855, 950, 950, 525,topType="NONE")
	dialog$track(ss)
	
	typeListener <- new(RActionListener)
	typeListener$setFunction(toJava(function(cmd,ActionEvent){
						if(cmd=="Gile's SS"){
							ss$setVisible(TRUE)
						}else{
							ss$setVisible(FALSE)
						}
					}))
	type$addListener(typeListener)
	
	pop <- new(Deducer::TextFieldWidget,"Population Size")
	pop$setInteger(TRUE)
	pop$setLowerBound(1)
	addComponent(panel, pop, 855, 475, 950, 50,topType="NONE")
	dialog$track(pop)
	
	actFunc <- function(x,y){
		
		data <- variableSelector$getSelectedData()		
		if(!is.null(data) && data != lastData){
			data <- eval(parse(text=data))
			NEst <- attr(data,"population.size.mid")
			if(!is.null(NEst))
				pop$setModel(as.character(NEst))
			else
				pop$setModel("")
			if(!is.null(NEst) && lastData=="")
				pop$setDefaultModel(as.character(NEst))
			else
				pop$setDefaultModel("")
			
		}
	}
	l <- new(RActionListener)
	l$setFunction(toJava(actFunc))
	variableSelector$getJComboBox()$addActionListener(l)
	
	getCall <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="") 
		data <- variableSelector$getModel()
		cmd <- "compute.weights(" %+% data %+%
				", weight.type=\"" %+% type$getModel() %+% "\", N=" %+% pop$getModel()
		if(type$getModel() == "Gile's SS")
				cmd <- cmd %+% ", number.ss.samples.per.iteration=" %+% ss$getModel()
		if(showRDS1){
			group.var <- variableList$getVariables()[1]
			cmd <- cmd %+% ", outcome.variable=\"" %+% group.var %+% "\""
		}
		cmd <- cmd %+% ")"
		cmd
	}
	
	hasRun <- function() lastData <<- variableSelector$getModel()
	
	check <- function(){
		if(type$getModel()=="Gile's SS" && pop$getModel()=="") 
			return("Please specify a population size estimate")
		if(ss$getModel()=="") 
			return("Please specify a sample size per iteration")
		''
	}
	
	return(list(panel=panel, getCall=getCall,hasRun=hasRun,check=check, widgets=list(type=type,ss=ss,pop=pop)))
}








