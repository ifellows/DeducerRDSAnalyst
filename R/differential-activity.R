

.makeDifferentialActivityDialog <- function(){
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(470L,445L)
	dialog$setTitle("Population Differential Activity")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystDifferentialActivity")
	
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.data.frame")
	addComponent(dialog, varSel, 20, 400, 600, 20)
	
	varBottom <- 490
	
	vars <- new(Deducer::VariableListWidget,"Variables",varSel)
	addComponent(dialog, vars, 20, 980, varBottom-140, 470)
	
	sub <- new(J("RDSAnalyst.SubsetWidget"),varSel)
	addComponent(dialog, sub, 650, 400, 860, 20)
	
	weightPanel <- .makeComputeWeightsPanel(dialog,varSel,vars)
	addComponent(dialog, weightPanel$panel, varBottom-140, 980, 860, 470)
	
	checkFunc <- function(x){
		if(length(vars$getVariables())==0) return("Please select a variable")
		tmp <- weightPanel$check()
		if(tmp!="") return(tmp)
		if(sub$getModel()!=""){
			data <- varSel$getModel()
			subExp <- sub$getModel()
			if(!J("RDSAnalyst.SubsetWidget")$isValidSubsetExp(subExp,data))
				return("Invalid subset")
		}
		""
	}
	dialog$setCheckFunction(toJava(checkFunc))
	
	runFunc <- function(x){
		wtCall <- weightPanel$getCall()
		weightPanel$hasRun()
		'%+%' <- function(x,y) paste(x,y,sep="") 
		data <- varSel$getModel()
		pop <- weightPanel$widgets$pop
		type <- weightPanel$widgets$type
		ss <- weightPanel$widgets$ss
		
		cmd <- "differential.activity.estimates(" %+% data %+% ", outcome.variable=" %+% vars$getRModel() %+%
				", \n\tweight.type=\"" %+% type$getModel() %+% "\""%+% 
				", N=" %+% pop$getModel() %+%
				", number.ss.samples.per.iteration=" %+% ss$getModel() 
		if(sub$getModel()!=""){
			cmd <- cmd %+% ", subset= " %+% sub$getModel()
			sub$addToHistory(sub$getModel(),data)
		}
		cmd <- cmd %+% ")"
		execute(cmd)
	}
	dialog$setRunFunction(toJava(runFunc))
	dialog
}
