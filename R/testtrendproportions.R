
.makeTestTrendProportionsDialog <- function() {
#	cmd <- "list.of.estimates <- listOfRDSEstimates()"
#	execute(cmd)

        Deducer <- J("org.rosuda.deducer.Deducer")

	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(500L, 550L)
	dialog$setTitle("Test to see if there is a Trend or Difference in the Proportions")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystTrendTest")
	
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.interval.estimate.list")
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
	
	vars <- new(Deducer::VariableListWidget, "Variables or Times (in order)", varSel)
	addComponent(dialog, vars, 20, 980, 490, 470)
	
        plotEstbox <- new(Deducer::CheckBoxesWidget,.jarray("Plot Estimates"))
	setSize(plotEstbox,400,75)	
	plotEstbox$setDefaultModel(c("Plot Estimates"))
        addComponent(dialog, plotEstbox, 700, 450, 900, 100, bottomType = "NONE")

        plotbox <- new(Deducer::CheckBoxesWidget,.jarray("Plot Distributions"))
	setSize(plotbox,400,75)	
#	plotbox$setDefaultModel(c("Plot Distributions"))
        addComponent(dialog, plotbox, 600, 450, 900, 100, bottomType = "NONE")

	report <- new(Deducer::ButtonGroupWidget,"Output",c("Graphics windows","PDF Report"))
	addComponent(dialog, report, 650, 980, 870, 470)
	
	checkFunc <- function(x) {
		if (length(vars$getVariables()) < 2) 
			return("Please select at least two variables")
		if (boot$getModel() == "") 
			return("# of bootstrap samples is unspecified")
		if (conf$getModel() == "") 
			return("Confidence level for intervals is unspecified")
		""
	}
	dialog$setCheckFunction(toJava(checkFunc))
	runFunc <- function(x) {
		"%+%" <- function(x, y) paste(x, y, sep = "")
		data <- varSel$getModel()
		fit <- data %+% "_rds_trend_test"

		pdf <- report$getModel() == "PDF Report"
		
		cmd <- ""
		if(pdf){
			plotFile <- tempfile(tmpdir=getwd())
			plotFile <-sprintf("%s.%s",sub("\\","/",plotFile,fixed=TRUE),"pdf")
			plotFile <- Deducer$addSlashes(plotFile)
			cmd <- "pdf(file=\"" %+% plotFile %+% "\")\n"
		}

		if (length(vars$getVariables()) > 2){
		cmd <- cmd %+% fit %+% " <- LRT.trend.test(data=" %+% data %+% ", " %+%
				"variables=" %+% vars$getRModel() %+% 
				", confidence.level=" %+% conf$getModel() %+% 
				", number.of.bootstrap.samples=" %+% boot$getModel()
		}else{
		cmd <- cmd %+% fit %+% " <- RDS.compare.two.proportions(data=" %+% data %+% ", " %+%
				"variables=" %+% vars$getRModel() %+%
                                ", confidence.level=" %+% conf$getModel() %+%
                                ", number.of.bootstrap.samples=" %+% boot$getModel()
		}
		if(plotbox$getModel()$size()>0 | plotEstbox$getModel()$size()>0) { 
		 if(plotbox$getModel()$size()>0 & plotEstbox$getModel()$size()>0) { 
		  cmd <- cmd %+% ", plot=c('estimates','distributions')"
		 }else{if(plotEstbox$getModel()$size()>0) { 
		  cmd <- cmd %+% ", plot=c('estimates')"
		 }else{
		  cmd <- cmd %+% ", plot=c('distributions')"
		 }}}
		cmd <- cmd %+% ")\n"
#		cmd <- cmd %+% "print(" %+% fit %+% ")\n"
#		cmd <- cmd %+% "\nrm('rds_trend_test')"

		if(pdf){
		 cmd <- cmd %+% "invisible(capture.output(dev.off()))\n"
                 if(.Platform$OS.type == "windows") {
		  cmd <- cmd %+% "shell.exec('" %+% plotFile %+% "')"
       		 } else if(.Platform$OS.type == "unix") {
		  cmd <- cmd %+% "system('open " %+% plotFile %+% "', ignore.stderr = TRUE)"
                 }
                }
		
		execute(cmd)
	}
	dialog$setRunFunction(toJava(runFunc))
	dialog
}
