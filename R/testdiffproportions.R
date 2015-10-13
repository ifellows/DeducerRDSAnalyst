
.makeTestDiffProportionsDialog <- function() {
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(500L, 625L)
	dialog$setTitle("Compare Population Frequencies")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystTestDifferenceInProportions")
	
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.data.frame")
	addComponent(dialog, varSel, 20, 400, 730, 20)

	var1 <- new(Deducer::SingleVariableWidget,"First Variable",varSel)
	addComponent(dialog, var1, 75, 980, 600, 470,
			topType="ABS",bottomType="NONE")

	var2 <- new(Deducer::SingleVariableWidget,"Second Variable",varSel)
	addComponent(dialog, var2, 200, 980, 600, 470,
			topType="ABS",bottomType="NONE")		
	
	sub <- new(J("RDSAnalyst.SubsetWidget"), varSel)
	sub$setTitle("Subset expression", TRUE)
	addComponent(dialog, sub, 325, 980, 475, 470,
			topType="ABS")	
	
	weightPanel <- .makeComputeWeightsPanel(dialog, varSel, NULL)
	addComponent(dialog, weightPanel$panel, 500, 980, 
			850, 470)
	
	boot <- new(Deducer::TextFieldWidget, "# Bootstraps")
	boot$setInteger(TRUE)
	boot$setDefaultModel("500")
	boot$setLowerBound(1)
	addComponent(dialog, boot, 755, 400, 850, 20, bottomType = "NONE")
	
	
	checkFunc <- function(x) {
		if(length(var1$getSelectedVariable())==0)
			return("Please select a First Variable")
		if(length(var2$getSelectedVariable())==0)
			return("Please select a Second Variable")
		if (boot$getModel() == "") 
			return("# of bootstrap samples is unspecified")
		tmp <- weightPanel$check()
		if (tmp != "") 
			return(tmp)
		if (sub$getModel() != "") {
			data <- varSel$getModel()
			subExp <- sub$getModel()
			if (!J("RDSAnalyst.SubsetWidget")$isValidSubsetExp(subExp, 
					data)) 
				return("Invalid subset")
		}
		""
	}
	dialog$setCheckFunction(toJava(checkFunc))
	runFunc <- function(x) {
		weightPanel$hasRun()
		"%+%" <- function(x, y) paste(x, y, sep = "")
		data <- varSel$getModel()
		pop <- weightPanel$widgets$pop
		type <- weightPanel$widgets$type
		ss <- weightPanel$widgets$ss
		uncertainty <- switch(type$getModel(),
				"RDS-I"="Salganik",
				"RDS-I (DS)"="Salganik",
				"RDS-II"="Salganik",
				"Gile's SS"="Gile",
				"Gile" 
		)
		cmd <- "freq_estimate1 <- RDS.bootstrap.intervals(" %+% 
				data %+% 
				", outcome.variable=" %+% var1$getRModel() %+% 
				", \n\tweight.type=\"" %+% type$getModel() %+% 
				"\", uncertainty=\"" %+% uncertainty %+% 
				"\", number.of.bootstrap.samples=" %+% boot$getModel()
		if(pop$getModel()!="")
			cmd <- cmd %+% ", N=" %+% pop$getModel()
		if(type$getModel() == "Gile's SS")
			cmd <- cmd %+% ", number.ss.samples.per.iteration=" %+% ss$getModel() 
		if (sub$getModel() != "") {
			cmd <- cmd %+% ", subset=" %+% sub$getModel()
			sub$addToHistory(sub$getModel(), data)
		}
		cmd <- cmd %+% ")\n"

		cmd <- cmd %+% "\nfreq_estimate2 <- RDS.bootstrap.intervals(" %+% 
				data %+% 
				", outcome.variable=" %+% var2$getRModel() %+% 
				", \n\tweight.type=\"" %+% type$getModel() %+% 
				"\", uncertainty=\"" %+% uncertainty %+% 
				"\", number.of.bootstrap.samples=" %+% boot$getModel()
		if(pop$getModel()!="")
			cmd <- cmd %+% ", N=" %+% pop$getModel()
		if(type$getModel() == "Gile's SS")
			cmd <- cmd %+% ", number.ss.samples.per.iteration=" %+% ss$getModel() 
		if (sub$getModel() != "") {
			cmd <- cmd %+% ", subset=" %+% sub$getModel()
			sub$addToHistory(sub$getModel(), data)
		}
		cmd <- cmd %+% ")\n"
		cmd <- cmd %+% "freq_estimate1\nfreq_estimate2\nRDS.compare.proportions(freq_estimate1,freq_estimate2)"
		execute(cmd)
	}
	dialog$setRunFunction(toJava(runFunc))
	dialog
}
