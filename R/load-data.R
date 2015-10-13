

.loadRDSATDialog <- function(){
	
	FileSelector <- J("org.rosuda.JGR.toolkit.FileSelector")
	JOptionPane <- J("javax.swing.JOptionPane")
	Deducer <- J("org.rosuda.deducer.Deducer")
	
	fileDialog <- new(FileSelector,.jnull(), "Load RDSAT Data", 0L, .jnull())
	fileDialog$setVisible(TRUE)
	file <- fileDialog$getFile()
	if(is.null(file))
		return()
	directory <- fileDialog$getDirectory()
	
	#For windows file paths
	directory <- gsub("\\\\","/",directory)
	
	fileName <- paste(directory,file,sep="")
	initial <- Deducer$makeValidVariableName(file)
	initial <- Deducer$getUniqueName(initial)
	#TODO: trim ext from initial
	rName <- JOptionPane$showInputDialog("Set data set name:",initial);
	if(is.null(rName))
		return()
	execute(paste(rName," <- read.rdsat(\"",Deducer$addSlashes(fileName),"\")",sep=""))	
}

.loadRDSOBJDialog <- function(){
	
	FileSelector <- J("org.rosuda.JGR.toolkit.FileSelector")
	JOptionPane <- J("javax.swing.JOptionPane")
	Deducer <- J("org.rosuda.deducer.Deducer")
	
	fileDialog <- new(FileSelector,.jnull(), "Load RDS Analyst Data (.rdsobj)", 0L, .jnull())
	fileDialog$setVisible(TRUE)
	file <- fileDialog$getFile()
	if(is.null(file))
		return()
	directory <- fileDialog$getDirectory()
	
	#For windows file paths
	directory <- gsub("\\\\","/",directory)
	
	fileName <- paste(directory,file,sep="")
	initial <- Deducer$makeValidVariableName(file)
	initial <- Deducer$getUniqueName(initial)
	#TODO: trim ext from initial
	rName <- JOptionPane$showInputDialog("Set data set name:",initial);
	if(is.null(rName))
		return()
	execute(paste(rName," <- read.rdsobj(\"",Deducer$addSlashes(fileName),"\")",sep=""))	
}
