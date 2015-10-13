

.makeDescriptivesDialog <- function(){
	
	JPanel <- J("javax.swing.JPanel")
	Dimension <- J("java.awt.Dimension")
	AnchorLayout <- J("org.rosuda.JGR.layout.AnchorLayout")
	Deducer <- J("org.rosuda.deducer.Deducer")
	
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(635L,730L)
	dialog$setTitle("Population Estimates")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystDescriptiveEstimates")
	
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.data.frame")
	addComponent(dialog, varSel, 20, 400, 550, 20)
	
	varBottom <- 300
	
	vars <- new(Deducer::VariableListWidget,"Variables",varSel)
	addComponent(dialog, vars, 20, 980, varBottom, 470)
	
	strata <- new(Deducer::VariableListWidget,"Stratify by:",varSel)
	addComponent(dialog, strata, varBottom + 20, 980, 550, 470)
	
	#Add back in when implemented
	sub <- new(J("RDSAnalyst.SubsetWidget"),varSel)
	sub$setTitle("Subset expression",TRUE)
	#addComponent(dialog, sub, 560, 980, 675, 510)
	
	weightPanel <- .makeComputeWeightsPanel(dialog,varSel,showRDS1=FALSE)
	addComponent(dialog, weightPanel$panel, 680, 980, 900, 510)
	
	panel <- new(JPanel)
	panel$setPreferredSize(new(Dimension,75L,100L))
	panel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Statistics"))
	panel$setLayout(new(AnchorLayout))
	addComponent(dialog, panel, 560, 490, 900, 20)
	
	
	statList <- new(Deducer::ListWidget)
	addComponent(panel, statList, 150, 400, 950, 50)
	statList$setDefaultModel(c("Median",
					"25th Percentile","75th Percentile"))
	dialog$track(statList)
	
	stats <- new(Deducer::ListWidget)
	addComponent(panel, stats, 150, 950, 950, 600)
	stats$setDefaultModel(c("Mean","St. Deviation"))
	dialog$track(stats)
	
	arb <- new(Deducer::AddRemoveButtons,statList,stats)
	addComponent(panel, arb, 100, 600, 950, 400)
	
	
	checkFunc <- function(x){
		if(length(vars$getVariables())==0) return("Please select a variable")
		if(length(stats$getItems())==0) return("Please select a statistic")
		#TODO: Check for drag from variable selector to statistics
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
		if(length(strata$getVariables())>0)
			strataCall <- ", strata="  %+% Deducer$makeRCollection(strata$getModel(),"d",FALSE)
		
		cmd <- "wtd.descriptive.table(vars=" %+% Deducer$makeRCollection(vars$getModel(),"d",FALSE) %+% 
				strataCall %+% 
				", data=" %+% data %+% 
				", func.names=" %+% stats$getRModel() %+%
				",\n\tweights=" %+% wtCall
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
