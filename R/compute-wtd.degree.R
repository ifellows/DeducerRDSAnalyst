# For "Compute Weights" Dialogue
# Test: Spawns a dialogue
# If population size estimate is empty, "please enter the estimate population size" pops up
###############################################################################


.makeComputeWeightedDegreeDialog <- function(showRDS1=TRUE){
	
	JSeparator <- J("javax.swing.JSeparator")
	Deducer <- J("org.rosuda.deducer.Deducer")
	RActionListener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(400L,300L)
	dialog$setTitle("Compute Weighted Degree")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystComputeWeightedDegree")
	
	obj <- new(Deducer::ObjectChooserWidget,"RDS Data",dialog)
	obj$setClassFilter("rds.data.frame")
	addComponent(dialog, obj, 20, 450, 180, 20)
	
	sep <- new(JSeparator)
	addComponent(dialog, sep, 230, 980, 180, 20,bottomType="NONE")
	
	var <- new(Deducer::TextFieldWidget,"New Variable")
	var$setDefaultModel("wtd.degree")
	addComponent(dialog, var, 20, 980, 180, 500)
	
	checkFunc <- function(x){
		if(is.null(obj$getModel())) 
			"No RDS data set loaded"
		else if(var$getModel()=="") 
			"Please enter a variable name"
		else {
			''
		}
	}
	dialog$setCheckFunction(toJava(checkFunc))
	
	runFunc <- function(x){
		varName <- Deducer$makeValidVariableName(var$getModel())
		'%+%' <- function(x,y) paste(x,y,sep="") 
		data <- obj$getModel()
		cmd <- data %+% "$" %+% varName %+% " <- wtd.median.degree(" %+% data %+% ")"
		execute(cmd)
	}
	dialog$setRunFunction(toJava(runFunc))
	dialog
}

.makeComputeWeightedDegreePanel <- function(dialog,variableSelector,variableList=NULL,showRDS1=TRUE ){
	
	JPanel <- J("javax.swing.JPanel")
	Dimension <- J("java.awt.Dimension")
	AnchorLayout <- J("org.rosuda.JGR.layout.AnchorLayout")
	RActionListener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	
	lastData <- ""
	
	panel <- new(JPanel)
	panel$setPreferredSize(new(Dimension,75L,100L))
	panel$setSize(new(Dimension,75L,100L))
	panel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Weighted Degree"))
	panel$setLayout(new(AnchorLayout))
	
	actFunc <- function(x,y){
		
		data <- variableSelector$getSelectedData()		
	}
	l <- new(RActionListener)
	l$setFunction(toJava(actFunc))
	variableSelector$getJComboBox()$addActionListener(l)
	
	getCall <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="") 
		data <- variableSelector$getModel()
		cmd <- "wtd.median.degree(" %+% data %+% ")"
		cmd
	}
	
	hasRun <- function() lastData <<- variableSelector$getModel()
	
	check <- function(){
		''
	}
	
	return(list(panel=panel, getCall=getCall,hasRun=hasRun,check=check, widgets=list()))
}
