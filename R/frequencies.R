
.makeFrequencyDialog <- function() {

	Deducer <- J("org.rosuda.deducer.Deducer")

	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(500L, 550L)
	dialog$setTitle("Population Frequency Estimates")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystFrequencyEstimates")
	
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.data.frame")
	addComponent(dialog, varSel, 20, 400, 490, 20)
	
	boot <- new(Deducer::TextFieldWidget, "# Bootstraps")
	boot$setInteger(TRUE)
	boot$setDefaultModel("500")
	boot$setLowerBound(1)
	addComponent(dialog, boot, 500, 400, 900, 210, bottomType = "NONE")
	
	conf <- new(Deducer::TextFieldWidget, "Confidence")
	conf$setNumeric(TRUE)
	conf$setDefaultModel("0.95")
	conf$setLowerBound(0)
	conf$setUpperBound(1)
	addComponent(dialog, conf, 500, 190, 900, 20, bottomType = "NONE")
	
	vars <- new(Deducer::VariableListWidget, "Variables", varSel)
	addComponent(dialog, vars, 20, 980, 490, 470)
	sub <- new(J("RDSAnalyst.SubsetWidget"), varSel)
	sub$setTitle("Subset expression", TRUE)
	addComponent(dialog, sub, 600, 400, 745, 
			20)
	
	weightPanel <- .makeComputeWeightsPanel(dialog, varSel, vars) #see compute-weights.R
	addComponent(dialog, weightPanel$panel, 500, 980, 
			900, 470)
	
	plottype <- new(Deducer::CheckBoxesWidget,"Diagnostic Plots",c("Convergence",
					"Bottleneck"))
	addComponent(dialog, plottype, 755, 400, 
			900, 20)	
	
	
	checkFunc <- function(x) {
		if (length(vars$getVariables()) == 0) 
			return("Please select a variable")
		if (boot$getModel() == "") 
			return("# of bootstrap samples is unspecified")
		if (conf$getModel() == "") 
			return("Confidence level for intervals is unspecified")
		tmp <- weightPanel$check()
		if (tmp != "") 
			return(tmp)
		if (sub$getModel() != "") {
			data <- varSel$getModel()
			subExp <- sub$getModel()
			if (!J("RDSAnalyst.SubsetWidget")$isValidSubsetExp(subExp, 
					data)) 
				return("Invalid subset")
			if(length(plottype$getSelectedItemText())>0)
				return("Diagnostic plots are not supported with a subset expression.")
		}
		""
	}
	dialog$setCheckFunction(toJava(checkFunc))
	runFunc <- function(x) {
		wtCall <- weightPanel$getCall()
		weightPanel$hasRun()
		"%+%" <- function(x, y) paste(x, y, sep = "")
		data <- varSel$getModel()
		varName <- Deducer$makeValidVariableName(vars$getRModel())
		fit <- data %+% "_" %+% varName
		pop <- weightPanel$widgets$pop
		type <- weightPanel$widgets$type
		ss <- weightPanel$widgets$ss
                uncertainty <- switch(type$getModel(),
                                      "RDS-I"="Salganik",
                                      "RDS-I (DS)"="Salganik",
                                      "RDS-II"="Salganik",
                                      "Gile's SS"="Gile",
                                      "Salganik" 
                                     )
		cmd <- fit %+% " <- RDS.bootstrap.intervals(" %+% 
				data %+% 
				", outcome.variable=" %+% vars$getRModel() %+% 
				", \n\tweight.type=\"" %+% type$getModel() %+% 
				"\", uncertainty=\"" %+% uncertainty %+% 
				"\", confidence.level=" %+% conf$getModel() %+% 
				", number.of.bootstrap.samples=" %+% boot$getModel()
		if(pop$getModel()!="")
			cmd <- cmd %+% ", N=" %+% pop$getModel()
		if(type$getModel() == "Gile's SS")
			cmd <- cmd %+% ", number.ss.samples.per.iteration=" %+% ss$getModel() 
				
		if (sub$getModel() != "") {
			subMod <- sub$getModel()
			cmd <- cmd %+% ", subset=" %+% subMod
			sub$addToHistory(sub$getModel(), data)
		}
		cmd <- cmd %+% ")\n"
		cmd <- cmd %+% "if(!is(" %+% fit %+% ",'rds.interval.estimate')){\n\tfor(i in 1:length(" %+% fit %+% ")){\n\t\tprint(" %+% fit %+% "[[i]])\n\t}\n}else{\n\tprint(" %+% fit %+% ")\n}"
#		cmd <- cmd %+% "\nrm('rds_freq_estimate')"
		estFunc <- switch(type$getModel(),
				"RDS-I"="RDS.I.estimates",
				"RDS-I (DS)"="RDS.I.estimates, smoothed=TRUE",
				"RDS-II"="RDS.II.estimates",
				"Gile's SS"="RDS.SS.estimates",
				"RDS.SS.estimates" 
		)
		pt <- plottype$getSelectedItemText()
		if("Convergence" %in% pt){
			pcmd <- "\ndev.new()\nconvergence.plot(" %+% data %+%
					", outcome.variable=" %+% vars$getRModel() %+% 
					", est.func=" %+% estFunc
			if(pop$getModel()!="")
				pcmd <- pcmd %+% ", N=" %+% pop$getModel()	
			if(type$getModel() == "Gile's SS")
				pcmd <- pcmd %+% ", number.ss.samples.per.iteration=" %+% ss$getModel() 	
			if(sub$getModel() != "")
				pcmd <- pcmd %+% ", subset=" %+% subMod
			pcmd <- pcmd %+% ", as.factor=TRUE)"
			cmd <- cmd %+% pcmd
		}
		if("Bottleneck" %in% pt){
			pcmd <- "\ndev.new()\nbottleneck.plot(" %+% data %+%
					", outcome.variable=" %+% vars$getRModel() %+% 
					", est.func=" %+% estFunc
			if(pop$getModel()!="")
				pcmd <- pcmd %+% ", N=" %+% pop$getModel()	
			if(type$getModel() == "Gile's SS")
				pcmd <- pcmd %+% ", number.ss.samples.per.iteration=" %+% ss$getModel() 	
			if(sub$getModel() != "")
				pcmd <- pcmd %+% ", subset=" %+% subMod
			pcmd <- pcmd %+% ", as.factor=TRUE)"
			cmd <- cmd %+% pcmd			
		}
		cmd <- cmd %+% "\nlist.of.estimates <- listOfRDSEstimates()"
		
		execute(cmd)
	}
	dialog$setRunFunction(toJava(runFunc))
	dialog
}
