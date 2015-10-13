

.makePlotDialog <- function(){
	Deducer <- J("org.rosuda.deducer.Deducer")
	
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(525L,445L)
	dialog$setTitle("Diagnostic Plots")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystRecruitmentDiagnostics")
	
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.data.frame")
	addComponent(dialog, varSel, 20, 400, 870, 20,topType="ABS",leftType="ABS")
	
	factVar <- new(Deducer::SingleVariableWidget,"Stratify by (optional)",varSel)
	addComponent(dialog, factVar, 120, 980, 270, 470,topType="ABS")
	
	type <- new(Deducer::CheckBoxesWidget,"Plots",c("Recruitment tree",
										"Network size by wave",					
										"Recruits by wave",
										"Recruits per seed",
										"Recruits per subject"))
	type$setDefaultModel("Recruitment tree")
	addComponent(dialog, type, 260, 980, 630, 470)
	
	report <- new(Deducer::ButtonGroupWidget,"Output",c("Graphics windows","PDF Report"))
	addComponent(dialog, report, 650, 980, 870, 470)
	
	runFunc <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="")
		
		pdf <- report$getModel() == "PDF Report"
		
		cmd <- ""
		if(pdf){
			plotFile <- tempfile(tmpdir=getwd())
			plotFile <-sprintf("%s.%s",sub("\\","/",plotFile,fixed=TRUE),"pdf")
			plotFile <- Deducer$addSlashes(plotFile)
			cmd <- "pdf(file=\"" %+% plotFile %+% "\")\n"
		}
		plotTypes <- type$getSelectedItemText()
		variable <- factVar$getSelectedVariable()
		stratParam <- if(is.jnull(variable)) "" else ", stratify.by='" %+% variable %+% "'"
		
		for(plotType in plotTypes){
			if(!pdf)
				cmd <- cmd %+% "dev.new()\n"
			cmd <- cmd %+% "plot(" %+% varSel$getSelectedData() %+% 
					", plot.type='" %+% plotType %+% "'" %+% stratParam %+% ")\n"
		}
		if(pdf){
		 cmd <- cmd %+% "dev.off()\n"
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
