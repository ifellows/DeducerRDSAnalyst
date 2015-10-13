
.makePlotRecruitmentTreeDialog <- function(){
	
	Deducer <- J("org.rosuda.deducer.Deducer")
	
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(525L,475L)
	dialog$setTitle("Plot Recruitment Tree")
	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystPlotRecruitmentTree")
	
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.data.frame")
	addComponent(dialog, varSel, 20, 400, 870, 20,topType="ABS",leftType="ABS")
	
	vertPosition <- 120
	
	VertexColVar <- new(Deducer::SingleVariableWidget, "Node Color (optional)", varSel)
	addComponent(dialog, VertexColVar,
			vertPosition, 980, vertPosition+150, 470,
			topType="ABS",bottomType="NONE")
	
	vertPosition <- vertPosition + 120
	VertexSizeVar <- new(Deducer::SingleVariableWidget, "Node Size (optional)", varSel)
	addComponent(dialog, VertexSizeVar,
			vertPosition, 980, vertPosition+150, 470,
			topType="ABS",bottomType="NONE")
	
	vertPosition <- vertPosition + 120
	VertexLabelVar <- new(Deducer::SingleVariableWidget, "Node Label (by default the id)", varSel)
	addComponent(dialog, VertexLabelVar,
			vertPosition, 980, vertPosition+170, 470,
			topType="ABS",bottomType="NONE")
	
	vertPosition <- vertPosition + 150
	ls <- new(Deducer::TextFieldWidget, "Node Label Size")
	ls$setNumeric(TRUE)
	ls$setDefaultModel("0.2")
	ls$setLowerBound(0)
	addComponent(dialog, ls,
			vertPosition, 980, vertPosition+100, 470, topType="ABS",bottomType="NONE")
	
	vertPosition <- vertPosition + 120
	report <- new(Deducer::ButtonGroupWidget,"Output",c("Graphics windows","PDF Report"))
	addComponent(dialog, report,
			vertPosition, 980, 870, 470,topType="ABS")
	
	runFunc <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="")
		
		pdf <- report$getModel() == "PDF Report"
		cmd <- ""
		if(pdf){
			plotFile <- tempfile(tmpdir=getwd())
			plotFile <-sprintf("%s.%s",sub("\\","/",plotFile,fixed=TRUE),"pdf")
			plotFile <- Deducer$addSlashes(plotFile)
			cmd <- "pdf(file=\"" %+% plotFile %+% "\", height=8.5,width=11)\n"
		}
		
		if(!pdf) cmd <- cmd %+% "dev.new(width=900,height=700)\n"
		cmd <- cmd %+% "reingold.tilford.plot(" %+% varSel$getSelectedData()  
		vertex.size <- VertexSizeVar$getSelectedVariable()
		if(!is.jnull(vertex.size)){
			cmd <- cmd %+% ", vertex.size='" %+% vertex.size %+% "'"
		}
		vertex.label <- VertexLabelVar$getSelectedVariable()
		if(!is.jnull(vertex.label)){
			cmd <- cmd %+% ", vertex.label='" %+% vertex.label %+% "'"
		}
		vertex.col <- VertexColVar$getSelectedVariable()
		if(!is.jnull(vertex.col)){
			cmd <- cmd %+% ", vertex.color='" %+% vertex.col %+% "'"
		}
		cmd <- cmd %+% ", vertex.label.cex=" %+% ls$getModel() %+% ")"
		if(pdf){
			cmd <- cmd %+% "\ndev.off()\n"
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
