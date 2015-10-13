#
#.makeSaveRDSDataDialog <- function(){
#	
#	FileSelector <- J("org.rosuda.JGR.toolkit.FileSelector")
#	
#	dialog <- new(Deducer::SimpleRDialog)
#	dialog$setSize(375L,125L)
#	dialog$setTitle("Save RDS Data Set")
#	dialog$setOkayCancel(FALSE,FALSE,dialog)
#	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystExportRDSData")
#	
#	obj <- new(Deducer::ObjectChooserWidget,"RDS Data",dialog)
#	obj$setClassFilter("rds.data.frame")
#	addComponent(dialog, obj, 10, 750, 42, 250,
#			topType="ABS",bottomType="NONE")
#	
#	runFunc <- function(x){
#		fileDialog <- new(FileSelector,.jnull(), "Save as .rdsobj", 1L, .jnull())
#		fileDialog$setVisible(TRUE)
#		file <- fileDialog$getFile()
#		if(is.null(file))
#			return()
#		if(substr(file,nchar(file)-6,nchar(file))!=".rdsobj")
#			file <- paste(file,".rdsobj",sep="")
#		
#		directory <- fileDialog$getDirectory()
#		
#		#For windows file paths
#		directory <- gsub("\\\\","/",directory)
#		fileName <- paste(directory,file,sep="")
#		execute(paste("write.rdsobj(",obj$getModel(),", '",fileName,"')",sep=""))
#		
#	}
#	dialog$setRunFunction(toJava(runFunc))
#	dialog
#}
#
#.makeSaveNetDrawDialog <- function(){
#	
#	FileSelector <- J("org.rosuda.JGR.toolkit.FileSelector")
#	
#	dialog <- new(Deducer::SimpleRDialog)
#	dialog$setSize(375L,125L)
#	dialog$setTitle("Export to NetDraw")
#	dialog$setOkayCancel(FALSE,FALSE,dialog)
#	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystExportRDSData")
#	
#	obj <- new(Deducer::ObjectChooserWidget,"RDS Data",dialog)
#	obj$setClassFilter("rds.data.frame")
#	addComponent(dialog, obj, 10, 750, 42, 250,
#			topType="ABS",bottomType="NONE")
#	
#	runFunc <- function(x){
#		fileDialog <- new(FileSelector,.jnull(), "Export to NetDraw", 1L, .jnull())
#		fileDialog$setVisible(TRUE)
#		file <- fileDialog$getFile()
#		if(is.null(file))
#			return()
#		directory <- fileDialog$getDirectory()
#		
#		#For windows file paths
#		directory <- gsub("\\\\","/",directory)
#		fileName <- paste(directory,file,sep="")
#		execute(paste("write.netdraw(",obj$getModel(),", '",fileName,"')",sep=""))
#		
#	}
#	dialog$setRunFunction(toJava(runFunc))
#	dialog
#}
#
#
#.makeSaveGraphVizDialog <- function(){
#	
#	FileSelector <- J("org.rosuda.JGR.toolkit.FileSelector")
#	
#	dialog <- new(Deducer::SimpleRDialog)
#	dialog$setSize(375L,125L)
#	dialog$setTitle("Export to GraphViz")
#	dialog$setOkayCancel(FALSE,FALSE,dialog)
#	dialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystExportRDSData")
#	
#	obj <- new(Deducer::ObjectChooserWidget,"RDS Data",dialog)
#	obj$setClassFilter("rds.data.frame")
#	addComponent(dialog, obj, 10, 750, 42, 250,
#			topType="ABS",bottomType="NONE")
#	
#	runFunc <- function(x){
#		fileDialog <- new(FileSelector,.jnull(), "Export to GraphViz", 1L, .jnull())
#		fileDialog$setVisible(TRUE)
#		file <- fileDialog$getFile()
#		if(is.null(file))
#			return()
#		if(substr(file,nchar(file)-2,nchar(file))!=".gv")
#			file <- paste(file,".gv",sep="")
#		directory <- fileDialog$getDirectory()
#		
#		#For windows file paths
#		directory <- gsub("\\\\","/",directory)
#		fileName <- paste(directory,file,sep="")
#		execute(paste("write.graphviz(",obj$getModel(),", '",fileName,"')",sep=""))
#		
#	}
#	dialog$setRunFunction(toJava(runFunc))
#	dialog
#}
#

