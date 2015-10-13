

.makeHomophilyDialog <- function(populationEstimate=TRUE){

	Dimension <- J("java.awt.Dimension")
	RActionListener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	
	lastData <- ""
	
	dialog <- new(Deducer::SimpleRDialog)
	dialog$setSize(436L,310L)
	dialog$setTitle("Homophily")
	if(populationEstimate)
		dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystPopulationHomophily")
	else
		dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystRecruitmentHomophily")
	varSel <- new(Deducer::VariableSelectorWidget)
	varSel$setRDataFilter("is.rds.data.frame")
	addComponent(dialog, varSel, 20, 400, 800, 20)
	
	varBottom <- if(populationEstimate) 720 else 800
	
	vars <- new(Deducer::VariableListWidget,"Variables",varSel)
	addComponent(dialog, vars, 20, 980, varBottom-200, 470)
	

	if(populationEstimate){
		N <- new(Deducer::TextFieldWidget,"Population Size Estimate")
		N$setInteger(TRUE)
		N$setLowerBound(1)
		N$setPreferredSize(new(Dimension,181L,48L))
		addComponent(dialog, N, varBottom+-190, 980, 800, 470,topType="NONE")
		
		actFunc <- function(x,y){

			data <- varSel$getSelectedData()	
			if(!is.null(data) && data != lastData){
				data <- eval(parse(text=data))
				NEst <- attr(data,"population.size.mid")
				if(!is.null(NEst))
					N$setModel(as.character(NEst))
				else
					N$setModel("")
				if(!is.null(NEst) && lastData=="")
					N$setDefaultModel(as.character(NEst))
				else
					N$setDefaultModel("")
					
			}
		}
		l <- new(RActionListener)
		l$setFunction(toJava(actFunc))
		varSel$getJComboBox()$addActionListener(l)
	}
	
	checkFunc <- function(x){
		if(length(vars$getVariables())==0) return("Please select a categorical variable")
		if(populationEstimate && N$getModel()=="") return("An estimate of the population size is required")

		""
	}
	dialog$setCheckFunction(toJava(checkFunc))
	runFunc <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="")
		recruit <- if(populationEstimate) "FALSE" else "TRUE"
		NCall <- if(!populationEstimate) "" else ", N=" %+% N$getModel()
		cmd <- "print(homophily.estimates(rds.data=" %+% varSel$getSelectedData() %+%
				", outcome.variable=" %+% vars$getRModel() %+% ", recruitment=" %+% recruit %+% NCall

		cmd <- cmd %+% "))"
		execute(cmd)
		lastData <<- varSel$getSelectedData()
	}
	dialog$setRunFunction(toJava(runFunc))
	dialog
}
