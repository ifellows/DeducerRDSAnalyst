

.makeContingencyDialog <- function(){
	
	Deducer <- J("org.rosuda.deducer.Deducer")
	
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(450L,570L)
	dialog$setTitle("Population Crosstabs")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystPopulationCrosstabs")
	
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.data.frame")
	addComponent(dialog, varSel, 20, 400, 600, 20)
	
	varBottom <- 250
	
	rows <- new(Deducer::VariableListWidget,"Rows",varSel)
	addComponent(dialog, rows, 20, 980, varBottom, 470)
	
	cols <- new(Deducer::VariableListWidget,"Columns",varSel)
	addComponent(dialog, cols, varBottom + 20, 980, 500, 470)
	
	stratum <- new(Deducer::SingleVariableWidget,"Stratify By:",varSel)
	addComponent(dialog, stratum, 500, 980, 600, 470)
	
	sub <- new(J("RDSAnalyst.SubsetWidget"),varSel)
	addComponent(dialog, sub, 620, 400, 765, 20)
	sub$setVisible(FALSE) # not implemented yet
	
	weightPanel <- .makeComputeWeightsPanel(dialog,varSel,showRDS1=FALSE)
	addComponent(dialog, weightPanel$panel, 620, 980, 900, 470)

	
	checkFunc <- function(x){
		if(length(rows$getVariables())==0) return("Please select a row variable")
		if(length(cols$getVariables())==0) return("Please select a column variable")
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
		strataCall <- ""
		if(length(stratum$getSelectedVariable())>0)
			strataCall <- ", stratum.var="  %+% stratum$getSelectedVariable()
		
		cmd <- "wtd.contingency.tables(row.vars=" %+% Deducer$makeRCollection(rows$getModel(),"d",FALSE) %+% 
				", col.vars=" %+% Deducer$makeRCollection(cols$getModel(),"d",FALSE) %+% 
				strataCall %+% 
				#", sample.counts=TRUE" %+% 
				", data=" %+% data %+% 
				",\n\tweights=" %+% wtCall
		if(sub$getModel()!=""){
			cmd <- cmd %+% ", subset=" %+% sub$getModel()
			sub$addToHistory(sub$getModel(),data)
		}
		cmd <- cmd %+% ")"
		execute(cmd)
	}
	dialog$setRunFunction(toJava(runFunc))
	dialog
}

