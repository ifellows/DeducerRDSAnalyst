
.onLoad <- function(libname, pkgname){
    ops <- options(warn = -1)
    on.exit(options(ops))
	deducerNotLoaded <- try(.deducer == .jnull(),silent=TRUE)
	if(inherits(deducerNotLoaded,"try-error") || deducerNotLoaded)
			return(NULL)
	
	.jpackage(pkgname, lib.loc=libname)
	
	RDSAnalyst <- J("RDSAnalyst.RDSAnalyst")
	RDSAnalyst$startUp()
	deducer.addMenu("RDS Data")
	deducer.addMenuItem("Load .rdsat File",,"DeducerRDSAnalyst:::.loadRDSATDialog()","RDS Data")
	deducer.addMenuItem("Load .rdsobj File",,"DeducerRDSAnalyst:::.loadRDSOBJDialog()","RDS Data")
	deducer.addMenuItem("Save RDS Data",,".getDialog('Save RDS Data')$run()","RDS Data")
	deducer.addMenuItem("Save RDS NetDraw",,".getDialog('Save RDS NetDraw')$run()","RDS Data")
	deducer.addMenuItem("Save RDS GraphViz",,".getDialog('Save RDS GraphViz')$run()","RDS Data")
	deducer.addMenuItem("Save RDS Gephi",,".getDialog('Save RDS Gephi')$run()","RDS Data")
	deducer.addMenuItem("Convert: Coupon --> RDS",,".getDialog('Convert: Coupon --> RDS')$run()","RDS Data")
	deducer.addMenuItem("Convert: Recruiter ID --> RDS",,".getDialog('Convert: Recruiter ID --> RDS')$run()","RDS Data")
	deducer.addMenuItem("Edit Meta Data",,".getDialog('Edit Meta Data')$run()","RDS Data")
	deducer.addMenuItem("Compute Weights",,".getDialog('Compute Weights')$run()","RDS Data")
	deducer.addMenuItem("Compute Weighted Degree",,".getDialog('Compute Weighted Degree')$run()","RDS Data")

	deducer.addMenu("RDS Sample")
	deducer.addMenuItem("Plot Recruitment Tree",,".getDialog('Plot Recruitment Tree')$run()","RDS Sample")
	deducer.addMenuItem("Diagnostic Plots",,".getDialog('Diagnostic Plots')$run()","RDS Sample")
	deducer.addMenuItem("Recruitment Homophily",,".getDialog('Recruitment Homophily')$run()","RDS Sample")
	deducer.addMenu("RDS Population")
	deducer.addMenuItem("Population Homophily",,".getDialog('Population Homophily')$run()","RDS Population")
	deducer.addMenuItem("Differential Activity",,".getDialog('Differential Activity')$run()","RDS Population")
	deducer.addMenuItem("Frequency Estimates",,".getDialog('Frequency Estimates')$run()","RDS Population")
	deducer.addMenuItem("Descriptive Estimates",,".getDialog('Descriptive Estimates')$run()","RDS Population")
	deducer.addMenuItem("Population Crosstabs",,".getDialog('Population Crosstabs')$run()","RDS Population")
	deducer.addMenuItem("Test Difference in Proportions",,".getDialog('Test Difference in Proportions')$run()","RDS Population")
	deducer.addMenuItem("Test Trend in Proportions",,".getDialog('Test Trend in Proportions')$run()","RDS Population")
	deducer.addMenuItem("Prior Distribution",,".getDialog('Prior Distribution')$run()","RDS Population")
	deducer.addMenuItem("Posterior Distribution",,".getDialog('Posterior Distribution')$run()","RDS Population")
	
	if(.jgr){
		menus <- jgr.getMenuNames()
		index <- which(menus=="Packages & Data")
		if(length(index)==0) 
			index <- 1
		if(RDSAnalyst$isPro()){
			jgr.insertMenu("RDS Data",index)
			jgr.insertMenuItem("RDS Data", "Import RDS Data", "J('RDSAnalyst.DataLoader')$run()",1)
			jgr.insertSubMenu("RDS Data","Export RDS Data",
					c("RDS Analyst (.rdsobj)","Flat File","Netdraw (.dl, .vna)","GraphViz (.gv)", "Gephi (.gexf)"),
					c("J('RDSAnalyst.RDSAnalyst')$runSave('rdsobj')","J('RDSAnalyst.RDSAnalyst')$runSaveFlatDialog()",
							"J('RDSAnalyst.RDSAnalyst')$runSave('netdraw')", 
							"J('RDSAnalyst.RDSAnalyst')$runSave('graphviz')",
							"J('RDSAnalyst.RDSAnalyst')$runSave('gephi')"),
					3)			
			jgr.addSubMenu("RDS Data", "Convert to RDS",
							c("Coupon Format","Recruiter ID Format"),
							c("deducer('Convert: Coupon --> RDS')","deducer('Convert: Recruiter ID --> RDS')"))
			jgr.addMenuSeparator("RDS Data")
			jgr.addMenuItem("RDS Data",'Edit Meta Data',"deducer('Edit Meta Data')")
			jgr.addMenuItem("RDS Data",'Compute Weights',"deducer('Compute Weights')")
			jgr.addMenuItem("RDS Data",'Compute Weighted Degree',"deducer('Compute Weighted Degree')")
			
			jgr.insertMenu("RDS Sample",index+1)
			jgr.addMenuItem("RDS Sample",'Plot Recruitment Tree',"deducer('Plot Recruitment Tree')")
			jgr.addMenuItem("RDS Sample",'Diagnostic Plots',"deducer('Diagnostic Plots')")
			jgr.addMenuItem("RDS Sample",'Recruitment Homophily',"deducer('Recruitment Homophily')")
			
			jgr.insertMenu("RDS Population",index+2)
			jgr.addMenuItem("RDS Population",'Frequency Estimates',"deducer('Frequency Estimates')")
			jgr.addMenuItem("RDS Population",'Descriptive Estimates',"deducer('Descriptive Estimates')")
			jgr.addMenuItem("RDS Population",'Population Crosstabs',"deducer('Population Crosstabs')")
			jgr.addMenuItem("RDS Population",'Test Difference in Proportions',"deducer('Test Difference in Proportions')")
			jgr.addMenuItem("RDS Population",'Test Trend in Proportions',"deducer('Test Trend in Proportions')")
			jgr.addMenuSeparator("RDS Population")
			jgr.addMenuItem("RDS Population",'Population Homophily',"deducer('Population Homophily')")
			jgr.addMenuItem("RDS Population",'Differential Activity',"deducer('Differential Activity')")

			jgr.addMenuSeparator("RDS Population")
			jgr.addSubMenu("RDS Population","Population Size",c("Prior Knowlege","Posterior Prediction"),
					c("deducer('Prior Distribution')","deducer('Posterior Distribution')"))
			
			
			jgr.addMenuSeparator("Packages & Data")
			jgr.addMenuItem("Packages & Data", "Example: faux", "data(faux)", silent=FALSE)
			jgr.addMenuItem("Packages & Data", "Example: fauxmadrona", "data(fauxmadrona)", silent=FALSE)
			jgr.addMenuItem("Packages & Data", "Example: fauxsycamore", "data(fauxsycamore)", silent=FALSE)
		}else{
			jgr.removeMenuItem("File",7)
			jgr.removeMenuItem("File",3)
			jgr.removeMenuItem("File",2)
			jgr.removeMenuItem("File",1)
			jgr.insertMenuItem("File", "Import RDS Data", "J('RDSAnalyst.DataLoader')$run()",1)
			jgr.insertSubMenu("File","Export RDS Data",
					c("RDS Analyst (.rdsobj)","Flat File","Netdraw (.dl, .vna)","GraphViz (.gv)","Gephi (.gexf)"),
					c("J('RDSAnalyst.RDSAnalyst')$runSave('rdsobj')","J('RDSAnalyst.RDSAnalyst')$runSaveFlatDialog()",
							"J('RDSAnalyst.RDSAnalyst')$runSave('netdraw')", 
							"J('RDSAnalyst.RDSAnalyst')$runSave('graphviz')",
							"J('RDSAnalyst.RDSAnalyst')$runSave('gephi')"),
					3)			
			
			jgr.removeMenuItem("Data",10)
			jgr.removeMenuItem("Data",9)
			jgr.removeMenuItem("Data",8)
			jgr.removeMenuItem("Data",7)
			jgr.insertMenuItem("Data",'Compute Weights',"deducer('Compute Weights')",4)
			jgr.insertMenuItem("Data",'Compute Weighted Degree',"deducer('Compute Weighted Degree')",4)
			jgr.addMenuSeparator("Data")
			jgr.addMenuItem("Data",'Edit Meta Data',"deducer('Edit Meta Data')")
			jgr.addSubMenu("Data", "Convert to RDS",
					c("Coupon Format","Recruiter ID Format"),
					c("deducer('Convert: Coupon --> RDS')","deducer('Convert: Recruiter ID --> RDS')"))
			
			jgr.removeMenu(5)
			
			jgr.insertMenu("Sample",index-2)
			jgr.addMenuItem("Sample",'Frequencies',"deducer('Frequencies')")
			jgr.addMenuItem("Sample",'Descriptives',"deducer('Descriptives')")
			jgr.addMenuItem("Sample",'Contingency Tables',"deducer('Contingency Tables')")
			jgr.addMenuSeparator("Sample")
			jgr.addMenuItem("Sample",'Recruitment Homophily',"deducer('Recruitment Homophily')")
			
			jgr.insertMenu("Population",index-1)
			jgr.addMenuItem("Population",'Frequency Estimates',"deducer('Frequency Estimates')")
			jgr.addMenuItem("Population",'Descriptive Estimates',"deducer('Descriptive Estimates')")
			jgr.addMenuItem("Population",'Population Crosstabs',"deducer('Population Crosstabs')")
			jgr.addMenuItem("Population",'Test Difference in Proportions',"deducer('Test Difference in Proportions')")
			jgr.addMenuItem("Population",'Test Trend in Proportions',"deducer('Test Trend in Proportions')")
			jgr.addMenuSeparator("Population")
			jgr.addMenuItem("Population",'Population Homophily',"deducer('Population Homophily')")
			jgr.addMenuItem("Population",'Differential Activity',"deducer('Differential Activity')")
			jgr.addMenuSeparator("Population")
			jgr.addSubMenu("Population","Population Size",c("Prior Knowlege","Posterior Prediction"),
					c("deducer('Prior Distribution')","deducer('Posterior Distribution')"))
			
			
			
			jgr.insertMenuSeparator("Plots",1)
			jgr.insertMenuItem("Plots",'Plot Recruitment Tree',"deducer('Plot Recruitment Tree')",1)
			jgr.insertMenuItem("Plots",'Recruitment Diagnostics',"deducer('Diagnostic Plots')",2)

			jgr.addMenuSeparator("Packages & Data")
			jgr.addMenuItem("Packages & Data", "Example: faux", "data(faux)", silent=FALSE)
			jgr.addMenuItem("Packages & Data", "Example: fauxmadrona", "data(fauxmadrona)", silent=FALSE)
			jgr.addMenuItem("Packages & Data", "Example: fauxsycamore", "data(fauxsycamore)",silent=FALSE)
		}
 	jgr.addMenuItem("Help", "RDS Analyst User Manual", "J('org.rosuda.deducer.toolkit.HelpButton')$showInBrowser('http://www.deducer.org/pmwiki/pmwiki.php?n=Main.RDSAnalyst')")
 	jgr.addMenuItem("Help", "RDS Analyst Reference Manual", "help(package='RDS')")
 	jgr.addMenuItem("Help", "Citation information", "citation('DeducerRDSAnalyst')",silent=FALSE)
	}
	
#	.registerDialog("Save RDS Data", .makeSaveRDSDataDialog)
#	.registerDialog("Save RDS NetDraw", .makeSaveNetDrawDialog)
#	.registerDialog("Save RDS GraphViz", .makeSaveGraphVizDialog)
	
	.registerDialog("Convert: Coupon --> RDS", function() .makeConvertDataDialog(TRUE))
	.registerDialog("Convert: Recruiter ID --> RDS", function() .makeConvertDataDialog(FALSE))
	.registerDialog("Edit Meta Data", .makeMetaDataDialog)
	.registerDialog("Compute Weights", .makeComputeWeightsDialog)
	.registerDialog("Compute Weighted Degree", .makeComputeWeightedDegreeDialog)
	
	.registerDialog("Population Homophily", function() .makeHomophilyDialog(TRUE))
	.registerDialog("Differential Activity", .makeDifferentialActivityDialog)
	.registerDialog("Recruitment Homophily", function() .makeHomophilyDialog(FALSE))
	.registerDialog("Plot Recruitment Tree", .makePlotRecruitmentTreeDialog)
	.registerDialog("Diagnostic Plots", .makePlotDialog)
	.registerDialog("Frequency Estimates", .makeFrequencyDialog)
	.registerDialog("Descriptive Estimates", .makeDescriptivesDialog)
	.registerDialog("Population Crosstabs", .makeContingencyDialog)
	.registerDialog("Test Difference in Proportions", .makeTestDiffProportionsDialog)
	.registerDialog("Test Trend in Proportions", .makeTestTrendProportionsDialog)
	
	.registerDialog("Prior Distribution", .makePriorDistribution)
	.registerDialog("Posterior Distribution", .makePosteriorDistribution)
}

.onAttach <- function(libname, pkgname){
  msg<-paste("copyright (c) 2012, Mark S. Handcock, University of California - Los Angeles\n",
"                    Ian E. Fellows, Fellows Statistics\n",
"                    Krista J. Gile, University of Massachusetts - Amherst\n",sep="")
  msg<-paste(msg,'For citation information, click "Help > Citation information".\n')
  msg<-paste(msg,'To get started, click "Help > RDS Analyst User Manual".\n')
  packageStartupMessage(msg)
}
