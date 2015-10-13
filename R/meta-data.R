.makeMetaDataDialog <- function(){
	
	JSeparator <- J("javax.swing.JSeparator")
	JPanel <- J("javax.swing.JPanel")
	AnchorLayout <- J("org.rosuda.JGR.layout.AnchorLayout")
	SingletonDJList <- J("org.rosuda.deducer.toolkit.SingletonDJList")
	SingletonAddRemoveButton <- J("org.rosuda.deducer.toolkit.SingletonAddRemoveButton")
	Dimension <- J("java.awt.Dimension")
	ActionListener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	AddRemoveButtons <- J("org.rosuda.deducer.widgets.AddRemoveButtons")
	
	rdsAttrDialog <- new(Deducer::SimpleRDialog)
	rdsAttrDialog$setSize(450L,600L)
	rdsAttrDialog$setTitle("RDS Meta Data")
	rdsAttrDialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystEditMetaData")
	
	varList <- new(Deducer::ListWidget,"Variables")
	addComponent(rdsAttrDialog, varList, 140, 450, 540, 50,
			topType="ABS")
	rdsAttrDialog$untrack(varList)
	
	vertPosition <- 170
	
	idPanel <- new(JPanel)
	idPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Subject ID"))
	idPanel$setLayout(new(J("java.awt.BorderLayout")))
	idPanel$setPreferredSize(new(Dimension,50L,50L))
	addComponent(rdsAttrDialog, idPanel, vertPosition, 950, vertPosition + 100, 600,
			topType="ABS",bottomType="NONE")
	
	id <- new(SingletonDJList)
	id$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	idPanel$add(id)
	
	idButton <- new(SingletonAddRemoveButton,c("add","remove"),c("add","remove"),
			id,varList$getList())
	idButton$setPreferredSize(new(Dimension,36L,36L))
	addComponent(rdsAttrDialog, idButton, vertPosition+15, 550, vertPosition+100, 482,
			topType="ABS",rightType="NONE",bottomType="NONE")
	
	vertPosition <- vertPosition + 100
	recruiterPanel <- new(JPanel)
	recruiterPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Recruiter ID"))
	recruiterPanel$setLayout(new(J("java.awt.BorderLayout")))
	recruiterPanel$setPreferredSize(new(Dimension,50L,50L))
	addComponent(rdsAttrDialog, recruiterPanel, vertPosition, 950, vertPosition+100, 600,
			topType="ABS",bottomType="NONE")
	
	recruiter <- new(SingletonDJList)
	recruiter$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	recruiterPanel$add(recruiter)
	
	recruiterButton <- new(SingletonAddRemoveButton,c("add","remove"),
			c("add","remove"),recruiter,varList$getList())
	recruiterButton$setPreferredSize(new(Dimension,36L,36L))
	addComponent(rdsAttrDialog, recruiterButton, vertPosition+15, 550, vertPosition+100, 482,
			topType="ABS",rightType="NONE",bottomType="NONE")
	
	vertPosition <- vertPosition + 100
	networkPanel <- new(JPanel)
	networkPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Network Size"))
	networkPanel$setLayout(new(J("java.awt.BorderLayout")))
	networkPanel$setPreferredSize(new(Dimension,50L,50L))
	addComponent(rdsAttrDialog, networkPanel, vertPosition, 950, vertPosition+100, 600,
			topType="ABS",bottomType="NONE")
	
	network <- new(SingletonDJList)
	network$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	networkPanel$add(network)
	
	networkButton <- new(SingletonAddRemoveButton,c("add","remove"),
			c("add","remove"),network,varList$getList())
	networkButton$setPreferredSize(new(Dimension,36L,36L))
	addComponent(rdsAttrDialog, networkButton, vertPosition+15, 550, vertPosition+100, 482,
			topType="ABS",rightType="NONE",bottomType="NONE")
	
	panel <- new(JPanel)
	panel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Optional"))
	panel$setLayout(new(AnchorLayout))
	addComponent(rdsAttrDialog, panel, 550, 950, 900, 50)
	panel$setSize(405L,134L)
	
	couponNumLabel <- new(Deducer::JLabel,"Max # of Coupons:")
	couponNumLabel$setHorizontalAlignment(4L)
	addComponent(panel, couponNumLabel, 200, 400, 150, 10,topType="ABS",bottomType="NONE")
	
	couponNum <- new(Deducer::TextFieldWidget)
	couponNum$setTitle("couponNum")
	couponNum$setInteger(TRUE)
	couponNum$setLowerBound(1)
	addComponent(panel, couponNum, 180, 560, 230, 410,topType="ABS",bottomType="NONE")
	
	popLabel <- new(Deducer::JLabel,"Population Size Estimate:")
	popLabel$setHorizontalAlignment(4L)
	addComponent(panel, popLabel, 600, 400, 150, 10,topType="ABS",bottomType="NONE")
	
	low <- new(Deducer::TextFieldWidget,"Low")
	low$setInteger(TRUE)
	low$setLowerBound(1)
	addComponent(panel, low, 400, 560, 200, 410,topType="ABS",bottomType="NONE")
	
	mid <- new(Deducer::TextFieldWidget,"Mid")
	mid$setInteger(TRUE)
	mid$setLowerBound(1)
	addComponent(panel, mid, 400, 720, 200, 570,topType="ABS",bottomType="NONE")
	
	high <- new(Deducer::TextFieldWidget,"High")
	high$setInteger(TRUE)
	high$setLowerBound(1)
	addComponent(panel, high, 400, 880, 200, 730,topType="ABS",bottomType="NONE")
	
	notes <- new(Deducer::TextAreaWidget,"Notes")
	addComponent(panel, notes, 800, 990, 990, 10,topType="ABS")
	
	obj <- new(Deducer::ObjectChooserWidget,"RDS Data",rdsAttrDialog)
	obj$setClassFilter("rds.data.frame")
	addComponent(rdsAttrDialog, obj, 10, 650, 42, 350,
			topType="ABS",bottomType="NONE")
	
	sep <- new(JSeparator)
	addComponent(rdsAttrDialog, sep, 120, 950, 42, 50,
			topType="ABS",bottomType="NONE")
	
	actionFunction <- function(cmd,event){
		dat <- obj$getModel()
		dat <- eval(parse(text=dat))
		
		varList$removeAllItems()
		varList$addItems(names(dat))
		
		id$getModel()$removeAllElements()
		variable <- attr(dat,"id")
		if(!is.null(variable) && variable %in% names(dat)){
			varList$removeItem(variable)
			id$getModel()$addElement(variable)
		}
		
		recruiter$getModel()$removeAllElements()
		variable <- attr(dat,"recruiter.id")
		if(!is.null(variable) && variable %in% names(dat)){
			varList$removeItem(variable)
			recruiter$getModel()$addElement(variable)
		}
		
		network$getModel()$removeAllElements()
		variable <- attr(dat,"network.size.variable")
		if(!is.null(variable) && variable %in% names(dat)){
			varList$removeItem(variable)
			network$getModel()$addElement(variable)
		}
		
		value <- attr(dat,"max.coupons")
		if(!is.null(value)){
			couponNum$setModel(as.character(value))
		}else{
			couponNum$setModel("")
		}
		
		value <- attr(dat,"population.size.low")
		if(!is.null(value)){
			low$setModel(as.character(value))
		}else{
			low$setModel("")
		}
		
		value <- attr(dat,"population.size.mid")
		if(!is.null(value)){
			mid$setModel(as.character(value))
		}else{
			mid$setModel("")
		}
		
		value <- attr(dat,"population.size.high")
		if(!is.null(value)){
			high$setModel(as.character(value))
		}else{
			high$setModel("")
		}
		
		value <- attr(dat,"notes")
		if(!is.null(value)){
			notes$setModel(as.character(value))
		}else{
			notes$setModel("")
		}
	}
	listener <- new(ActionListener)
	listener$setFunction(toJava(actionFunction))
	obj$getComboBox()$addActionListener(listener)
	
	
	rdsAttrDialog$getOkayCancel()$getResetButton()$addActionListener(listener)
	
	checkFunc <- function(x){
		if(id$getModel()$getSize()==0L) return("Subject ID is required")
		if(recruiter$getModel()$getSize()==0L) return("Recruiter ID is required")
		if(network$getModel()$getSize()==0L) return("Subject network size is required")
		''
	}
	rdsAttrDialog$setCheckFunction(toJava(checkFunc))
	
	runFuncRDS <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="")
		cmd <- ""
		dat <- obj$getModel()
		new.dat <- dat
		
		rec.id <- recruiter$getModel()$getElementAt(0L)
		subj.id <- id$getModel()$getElementAt(0L)
		net <- network$getModel()$getElementAt(0L)
		coup <- couponNum$getModel()
		est.low <- low$getModel()
		est.mid <- mid$getModel()
		est.high <- high$getModel()
		not <- notes$getModel()
		not <- gsub("\\","\\\\",not,fixed=TRUE)
		not <- gsub("'","\\'",not,fixed=TRUE)
		
		if(coup == "") coup <- "NULL"
		if(est.low == "") est.low <- "NA"
		if(est.mid == "") est.mid <- "NA"
		if(est.high == "") est.high <- "NA"
		if(not == "") not <- "NULL" else not <- "'"%+%not%+%"',"
		
		cmd <- new.dat %+% " <- as.rds.data.frame("%+%dat%+% ","
                if(id$getModel()$getSize()!=0L){
		 cmd <- cmd %+% " id='" %+% subj.id %+% "',"
                }
		cmd <- cmd %+% " recruiter.id='" %+%rec.id %+%
				"'\n\t, network.size='" %+% net %+% 
				"', population.size=c("%+%est.low%+%","%+%est.mid%+%"," %+%est.high%+%")" %+%
				", max.coupons=" %+% coup %+%
				"\n\t, notes=" %+% not %+% ")\n" %+%
				new.dat %+% "$seed <- get.seed.id("%+%new.dat%+%")\n" %+%
				new.dat %+% "$wave <- get.wave("%+%new.dat%+%")"
		execute(cmd)
	}
	
	rdsAttrDialog$setRunFunction(toJava(runFuncRDS))
	rdsAttrDialog
}



.makeConvertDataDialog <- function(couponFormat=FALSE){
	
	JSeparator <- J("javax.swing.JSeparator")
	JPanel <- J("javax.swing.JPanel")
	AnchorLayout <- J("org.rosuda.JGR.layout.AnchorLayout")
	SingletonDJList <- J("org.rosuda.deducer.toolkit.SingletonDJList")
	SingletonAddRemoveButton <- J("org.rosuda.deducer.toolkit.SingletonAddRemoveButton")
	Dimension <- J("java.awt.Dimension")
	ActionListener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	AddRemoveButtons <- J("org.rosuda.deducer.widgets.AddRemoveButtons")
	
	lastID <- NULL
	lastRID <- NULL
	lastNet <- NULL
	lastSCoup <- NULL
	lastCoup <- NULL
	
	rdsAttrDialog <- new(Deducer::SimpleRDialog)
	rdsAttrDialog$setSize(450L,600L)
	if(couponFormat)
		rdsAttrDialog$setTitle("Data Formatter: Coupon --> RDS")
	else
		rdsAttrDialog$setTitle("Data Formatter: Recruiter ID --> RDS")
	rdsAttrDialog$addHelpButton("pmwiki.php?n=Main.RDSAnalystConvertToRDS")
	
	varList <- new(Deducer::ListWidget,"Variables")
	addComponent(rdsAttrDialog, varList, 140, 450, 540, 50,
			topType="ABS")
	varList$addItems(c("a","b"))
	
	vertPosition <- 170
	
	idPanel <- new(JPanel)
	idPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Subject ID"))
	idPanel$setLayout(new(J("java.awt.BorderLayout")))
	idPanel$setPreferredSize(new(Dimension,50L,50L))
	addComponent(rdsAttrDialog, idPanel, vertPosition, 950, vertPosition + 100, 600,
			topType="ABS",bottomType="NONE")
	
	id <- new(SingletonDJList)
	id$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	idPanel$add(id)
	
	idButton <- new(SingletonAddRemoveButton,c("add","remove"),c("add","remove"),
			id,varList$getList())
	idButton$setPreferredSize(new(Dimension,36L,36L))
	addComponent(rdsAttrDialog, idButton, vertPosition+15, 550, vertPosition+100, 482,
			topType="ABS",rightType="NONE",bottomType="NONE")
	if(!couponFormat){
		vertPosition <- vertPosition + 100
		recruiterPanel <- new(JPanel)
		recruiterPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Recruiter ID"))
		recruiterPanel$setLayout(new(J("java.awt.BorderLayout")))
		recruiterPanel$setPreferredSize(new(Dimension,50L,50L))
		addComponent(rdsAttrDialog, recruiterPanel, vertPosition, 950, vertPosition+100, 600,
				topType="ABS",bottomType="NONE")
		
		recruiter <- new(SingletonDJList)
		recruiter$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
		recruiterPanel$add(recruiter)
		
		recruiterButton <- new(SingletonAddRemoveButton,c("add","remove"),
				c("add","remove"),recruiter,varList$getList())
		recruiterButton$setPreferredSize(new(Dimension,36L,36L))
		addComponent(rdsAttrDialog, recruiterButton, vertPosition+15, 550, vertPosition+100, 482,
				topType="ABS",rightType="NONE",bottomType="NONE")
	}	
	vertPosition <- vertPosition + 100
	networkPanel <- new(JPanel)
	networkPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Network Size"))
	networkPanel$setLayout(new(J("java.awt.BorderLayout")))
	networkPanel$setPreferredSize(new(Dimension,50L,50L))
	addComponent(rdsAttrDialog, networkPanel, vertPosition, 950, vertPosition+100, 600,
			topType="ABS",bottomType="NONE")
	
	network <- new(SingletonDJList)
	network$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	networkPanel$add(network)
	
	networkButton <- new(SingletonAddRemoveButton,c("add","remove"),
			c("add","remove"),network,varList$getList())
	networkButton$setPreferredSize(new(Dimension,36L,36L))
	addComponent(rdsAttrDialog, networkButton, vertPosition+15, 550, vertPosition+100, 482,
			topType="ABS",rightType="NONE",bottomType="NONE")
	
	if(couponFormat){
		vertPosition <- vertPosition + 100
		subjCouponPanel <- new(JPanel)
		subjCouponPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Subject's Coupon"))
		subjCouponPanel$setLayout(new(J("java.awt.BorderLayout")))
		subjCouponPanel$setPreferredSize(new(Dimension,50L,50L))
		addComponent(rdsAttrDialog, subjCouponPanel, vertPosition, 950, vertPosition+100, 600,
				topType="ABS",bottomType="NONE")
		
		subjCoupon <- new(SingletonDJList)
		subjCoupon$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
		subjCouponPanel$add(subjCoupon)
		
		subjCouponButton <- new(SingletonAddRemoveButton,c("add","remove"),
				c("add","remove"),subjCoupon,varList$getList())
		subjCouponButton$setPreferredSize(new(Dimension,36L,36L))
		addComponent(rdsAttrDialog, subjCouponButton, vertPosition+15, 550, vertPosition+100, 482,
				topType="ABS",rightType="NONE",bottomType="NONE")
		
		vertPosition <- vertPosition + 100
		couponList <- new(Deducer::ListWidget,"Coupons")
		addComponent(rdsAttrDialog, couponList, vertPosition, 950, 540, 600,
				topType="ABS")
		
		couponButtons <- new(AddRemoveButtons,varList,couponList)
		couponButtons$setPreferredSize(new(Dimension,36L,80L))
		addComponent(rdsAttrDialog, couponButtons, vertPosition+25, 550, vertPosition+100, 482,
				topType="ABS",rightType="NONE",bottomType="NONE")
	}
	
	obj <- new(Deducer::ObjectChooserWidget,"Data set",rdsAttrDialog)
	obj$setClassFilter("data.frame")
	obj$setIncludeInherited(FALSE)
	addComponent(rdsAttrDialog, obj, 10, 400, 42, 100,
			topType="ABS",bottomType="NONE")
	
	newData <- new(Deducer::TextFieldWidget,"Assign to")
	addComponent(rdsAttrDialog, newData, 10, 900, 42, 600,
			topType="ABS",bottomType="NONE")
	
	sep <- new(JSeparator)
	addComponent(rdsAttrDialog, sep, 120, 950, 42, 50,
			topType="ABS",bottomType="NONE")
	
	panel <- new(JPanel)
	panel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Optional"))
	panel$setLayout(new(AnchorLayout))
	addComponent(rdsAttrDialog, panel, 550, 950, 900, 50)
	panel$setSize(405L,134L)
	
	couponNumLabel <- new(Deducer::JLabel,"Max # of Coupons:")
	couponNumLabel$setHorizontalAlignment(4L)
	addComponent(panel, couponNumLabel, 200, 400, 150, 10,topType="ABS",bottomType="NONE")
	
	couponNum <- new(Deducer::TextFieldWidget)
	couponNum$setTitle("couponNum")
	couponNum$setInteger(TRUE)
	couponNum$setLowerBound(1)
	addComponent(panel, couponNum, 180, 560, 230, 410,topType="ABS",bottomType="NONE")
	rdsAttrDialog$track(couponNum)
	
	popLabel <- new(Deducer::JLabel,"Population Size Estimate:")
	popLabel$setHorizontalAlignment(4L)
	addComponent(panel, popLabel, 600, 400, 150, 10,topType="ABS",bottomType="NONE")
	
	low <- new(Deducer::TextFieldWidget,"Low")
	low$setInteger(TRUE)
	low$setLowerBound(1)
	addComponent(panel, low, 400, 560, 200, 410,topType="ABS",bottomType="NONE")
	rdsAttrDialog$track(low)
	
	mid <- new(Deducer::TextFieldWidget,"Mid")
	mid$setInteger(TRUE)
	mid$setLowerBound(1)
	addComponent(panel, mid, 400, 720, 200, 570,topType="ABS",bottomType="NONE")
	rdsAttrDialog$track(mid)
	
	high <- new(Deducer::TextFieldWidget,"High")
	high$setInteger(TRUE)
	high$setLowerBound(1)
	addComponent(panel, high, 400, 880, 200, 730,topType="ABS",bottomType="NONE")
	rdsAttrDialog$track(high)
	
	notes <- new(Deducer::TextAreaWidget,"Notes")
	addComponent(panel, notes, 800, 990, 990, 10,topType="ABS")
	rdsAttrDialog$track(notes)
	
	if(couponFormat)
		rdsAttrDialog$setSize(573L,721L)
	
	
	actionFunction <- function(cmd,event){
		dat <- obj$getModel()
		dat <- eval(parse(text=dat),envir=.GlobalEnv)
		
		newData$setModel(paste(obj$getModel(),".rds",sep=""))
		
		varList$removeAllItems()
		varList$addItems(names(dat))
		
		id$getModel()$removeAllElements()
		variable <- lastID
		if(!is.null(variable) && variable %in% names(dat)){
			varList$removeItem(variable)
			id$getModel()$addElement(variable)
		}
		
		if(!couponFormat){
			recruiter$getModel()$removeAllElements()
			variable <- lastRID
			if(!is.null(variable) && variable %in% names(dat)){
				varList$removeItem(variable)
				recruiter$getModel()$addElement(variable)
			}
		}else{
			
			subjCoupon$getModel()$removeAllElements()
			variable <- lastSCoup
			if(!is.null(variable) && variable %in% names(dat)){
				varList$removeItem(variable)
				subjCoupon$getModel()$addElement(variable)
			}
			
			couponList$removeAllItems()
			variables <- lastCoup
			for(variable in variables){
				if(!is.null(variable) && variable %in% names(dat)){
					varList$removeItem(variable)
					couponList$addItem(variable)
				}
			}
			
		}
		
		network$getModel()$removeAllElements()
		variable <- lastNet
		if(!is.null(variable) && variable %in% names(dat)){
			varList$removeItem(variable)
			network$getModel()$addElement(variable)
		}
		
	}
	listener <- new(ActionListener)
	listener$setFunction(toJava(actionFunction))
	obj$getComboBox()$addActionListener(listener)
	
	resetFunc <- function(cmd,a){
		id$getModel()$removeAllElements()
		if(!couponFormat) 
			recruiter$getModel()$removeAllElements()
		else{
			subjCoupon$getModel()$removeAllElements()
			couponList$removeAllItems()
		}
		network$getModel()$removeAllElements()
		
		lastID <<- NULL
		lastRID <<- NULL
		lastNet <<- NULL
		lastSCoup <<- NULL
		lastCoup <<- NULL
		
	}
	resetListener <- new(ActionListener)
	resetListener$setFunction(toJava(resetFunc))	
	rdsAttrDialog$getOkayCancel()$getResetButton()$addActionListener(resetListener)
	
	checkFunc <- function(x){
		if(!couponFormat && recruiter$getModel()$getSize()==0L) return("Recruiter ID is required")
#		if(id$getModel()$getSize()==0L) return("Subject ID is required")
		if(network$getModel()$getSize()==0L) return("Subject network size is required")
		if(newData$getModel()=="") return("Converted dataset name must be defined")
		if(couponFormat){
			if(subjCoupon$getModel()$getSize()==0L) return("Subject's coupon must be defined")
			if(couponList$getModel()$getSize()==0L) return("Coupons must be defined")
		}
		''
	}
	rdsAttrDialog$setCheckFunction(toJava(checkFunc))
	
	runFuncRDS <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="")
		cmd <- ""
		dat <- obj$getModel()
		new.dat <- J("org.rosuda.deducer.Deducer")$makeValidVariableName(newData$getModel())
		
 		if(id$getModel()$getSize()==0L) {
		  lastID  <<- subj.id <- NULL
                }else{
		  lastID  <<- subj.id <- id$getModel()$getElementAt(0L)
                }
		lastRID <<- rec.id <- recruiter$getModel()$getElementAt(0L)
		lastNet <<- net <- network$getModel()$getElementAt(0L)
		coup <- couponNum$getModel()
		est.low <- low$getModel()
		est.mid <- mid$getModel()
		est.high <- high$getModel()
		not <- notes$getModel()
		not <- gsub("'","\\'",not,fixed=TRUE)
		
		if(coup == "") coup <- "NULL"
		if(est.low == "") est.low <- "NA"
		if(est.mid == "") est.mid <- "NA"
		if(est.high == "") est.high <- "NA"
		if(not == "") not <- "NULL" else not <- "'"%+%not%+%"'"
		
		cmd <- new.dat %+% " <- as.rds.data.frame("%+%dat%+%","
                if(id$getModel()$getSize()!=0L){
		 cmd <- cmd %+% " id='" %+% subj.id %+% "',"
                }
		cmd <- cmd %+%  " recruiter.id='" %+%rec.id %+%
				"'\n\t, network.size='" %+% net %+% 
				"', population.size=c("%+%est.low%+%","%+%est.mid%+%"," %+%est.high%+%")" %+%
				", max.coupons=" %+% coup %+%
				"\n\t, notes=" %+% not %+% ")\n" %+%
				new.dat %+% "$seed <- get.seed.id("%+%new.dat%+%")\n" %+%
				new.dat %+% "$wave <- get.wave("%+%new.dat%+%")"
		execute(cmd)
	}
	
	runFuncCoupon <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="")
		dat <- obj$getModel()
		new.dat <- J("org.rosuda.deducer.Deducer")$makeValidVariableName(newData$getModel())
		
 		if(id$getModel()$getSize()==0L) {
		  lastID  <<- subj.id <- NULL
                }else{
		  lastID  <<- subj.id <- id$getModel()$getElementAt(0L)
                }
		lastNet<<- net <- network$getModel()$getElementAt(0L)
		coup <- couponNum$getModel()
		est.low <- low$getModel()
		est.mid <- mid$getModel()
		est.high <- high$getModel()
		not <- notes$getModel()
		not <- gsub("\\","\\\\",not,fixed=TRUE)
		not <- gsub("'","\\'",not,fixed=TRUE)
		
		lastSCoup <<- subj.coupon <- subjCoupon$getModel()$getElementAt(0L)
		lastCoup <<- couponList$getItems()
		
		cmd1 <- new.dat %+% " <- " %+% dat %+% "\n"
                if(id$getModel()$getSize()==0L){
		 cmd1 <- cmd1 %+% new.dat %+% "$id <- 1:nrow(" %+% new.dat %+% ")\n"
                }
		cmd1 <- cmd1 %+% new.dat %+% "$recruiter.id <- rid.from.coupons(" %+% new.dat %+% ","
                if(id$getModel()$getSize()!=0L){
		 cmd1 <- cmd1 %+% "\n subject.id='" %+% subj.id %+% "',"
                }
		cmd1 <- cmd1 %+% " subject.coupon='" %+% subj.coupon %+% 
				 "', coupon.variables=" %+% couponList$getRModel() %+% ")\n"
		
		rec.id <- "recruiter.id"
		
		if(coup == "") coup <- "NULL"
		if(est.low == "") est.low <- "NA"
		if(est.mid == "") est.mid <- "NA"
		if(est.high == "") est.high <- "NA"
		if(not == "") not <- "NULL" else not <- "'"%+%not%+%"'"
		
		cmd2 <- new.dat %+% " <- as.rds.data.frame("%+%new.dat%+%","
                if(id$getModel()$getSize()!=0L){
		 cmd2 <- cmd2 %+% " id='" %+% subj.id%+%"',"
                }
		cmd2 <- cmd2 %+% " recruiter.id='" %+%rec.id %+%
				 "'\n\t, network.size='" %+% net %+% 
				 "', population.size=c("%+%est.low%+%","%+%est.mid%+%"," %+%est.high%+%")" %+%
				 ", max.coupons=" %+% coup %+%
				 "\n\t, notes=" %+% not %+% ")\n" %+%
				 new.dat %+% "$seed <- get.seed.id("%+%new.dat%+%")\n" %+%
				 new.dat %+% "$wave <- get.wave("%+%new.dat%+%")"
		execute(cmd1 %+% cmd2)
	}
	
	if(!couponFormat)
		rdsAttrDialog$setRunFunction(toJava(runFuncRDS))
	else
		rdsAttrDialog$setRunFunction(toJava(runFuncCoupon))
	
	rdsAttrDialog
}





.makePostLoadDialog <- function(dataName=NULL){
	
	couponFormat <-TRUE
	JSeparator <- J("javax.swing.JSeparator")
	JPanel <- J("javax.swing.JPanel")
	AnchorLayout <- J("org.rosuda.JGR.layout.AnchorLayout")
	SingletonDJList <- J("org.rosuda.deducer.toolkit.SingletonDJList")
	SingletonAddRemoveButton <- J("org.rosuda.deducer.toolkit.SingletonAddRemoveButton")
	Dimension <- J("java.awt.Dimension")
	ActionListener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	AddRemoveButtons <- J("org.rosuda.deducer.widgets.AddRemoveButtons")
	RActionlistener <- J("org.rosuda.deducer.widgets.event.RActionListener")
	
	lastID <- NULL
	lastRID <- NULL
	lastNet <- NULL
	lastSCoup <- NULL
	lastCoup <- NULL
	
	
	updateFormat <- function(){
		if(!is.jnull(dataFormat$getModel()))
			couponFormat <<- dataFormat$getModel()=="Coupon"
		rdsAttrDialog$remove(subjCouponPanel)
		rdsAttrDialog$remove(subjCouponButton)
		rdsAttrDialog$remove(couponList)
		rdsAttrDialog$remove(couponButtons)
		rdsAttrDialog$remove(recruiterPanel)
		rdsAttrDialog$remove(recruiterButton)
		
		subjCoupon$getModel()$removeAllElements()
		couponList$reset()
		recruiter$getModel()$removeAllElements()
		varList$reset()
		network$getModel()$removeAllElements()
		id$getModel()$removeAllElements()
		if(couponFormat){
			vertPosition <- 320
			addComponent(rdsAttrDialog, subjCouponPanel, vertPosition, 950, vertPosition+100, 600,
					topType="ABS",bottomType="NONE")
			addComponent(rdsAttrDialog, subjCouponButton, vertPosition+15, 550, vertPosition+100, 482,
					topType="ABS",rightType="NONE",bottomType="NONE")
			vertPosition <- vertPosition + 80
			addComponent(rdsAttrDialog, couponList, vertPosition, 950, 540, 600,
					topType="ABS")
			addComponent(rdsAttrDialog, couponButtons, vertPosition+25, 550, vertPosition+100, 482,
					topType="ABS",rightType="NONE",bottomType="NONE")
		}else{
			vertPosition <- 320
			addComponent(rdsAttrDialog, recruiterPanel, vertPosition, 950, vertPosition+100, 600,
					topType="ABS",bottomType="NONE")
			addComponent(rdsAttrDialog, recruiterButton, vertPosition+15, 550, vertPosition+100, 482,
					topType="ABS",rightType="NONE",bottomType="NONE")
		}
		
		if(!couponFormat)
			rdsAttrDialog$setRunFunction(toJava(runFuncRDS))
		else
			rdsAttrDialog$setRunFunction(toJava(runFuncCoupon))
		
		rdsAttrDialog$validate()
		rdsAttrDialog$repaint()
	}
	
	rdsAttrDialog <- new(Deducer::SimpleRDialog)
	rdsAttrDialog$setSize(600L,730L)
	rdsAttrDialog$setTitle("Load RDS Data")
	
	dataFormat <- new(Deducer::ButtonGroupWidget,"Data Format",c("Coupon","Recuiter ID"))
	addComponent(rdsAttrDialog, dataFormat, 10, 600, 120, 400, topType="ABS")
	
	actFunc <- function(a,b){
		updateFormat()
	}
	
	lis <- new(RActionlistener)
	lis$setFunction(toJava(actFunc))
	dataFormat$addListener(lis)
	
	sep <- new(JSeparator)
	addComponent(rdsAttrDialog, sep, 120, 950, 42, 50,
			topType="ABS",bottomType="NONE")
	
	varList <- new(Deducer::ListWidget,"Variables")
	addComponent(rdsAttrDialog, varList, 140, 450, 540, 50,
			topType="ABS")
	varList$setDefaultModel(eval(parse(text=paste("names(",dataName,")")),envir=globalenv()))
	vertPosition <- 170
	
	idPanel <- new(JPanel)
	idPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Subject ID"))
	idPanel$setLayout(new(J("java.awt.BorderLayout")))
	idPanel$setPreferredSize(new(Dimension,50L,50L))
	addComponent(rdsAttrDialog, idPanel, vertPosition, 950, vertPosition + 100, 600,
			topType="ABS",bottomType="NONE")
	
	id <- new(SingletonDJList)
	id$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	idPanel$add(id)
	
	idButton <- new(SingletonAddRemoveButton,c("add","remove"),c("add","remove"),
			id,varList$getList())
	idButton$setPreferredSize(new(Dimension,36L,36L))
	addComponent(rdsAttrDialog, idButton, vertPosition+15, 550, vertPosition+100, 482,
			topType="ABS",rightType="NONE",bottomType="NONE")

	recruiterPanel <- new(JPanel)
	recruiterPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Recruiter ID"))
	recruiterPanel$setLayout(new(J("java.awt.BorderLayout")))
	recruiterPanel$setPreferredSize(new(Dimension,50L,50L))
	
	
	recruiter <- new(SingletonDJList)
	recruiter$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	recruiterPanel$add(recruiter)
	
	recruiterButton <- new(SingletonAddRemoveButton,c("add","remove"),
			c("add","remove"),recruiter,varList$getList())
	recruiterButton$setPreferredSize(new(Dimension,36L,36L))
	
	vertPosition <- vertPosition + 70
	networkPanel <- new(JPanel)
	networkPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Network Size"))
	networkPanel$setLayout(new(J("java.awt.BorderLayout")))
	networkPanel$setPreferredSize(new(Dimension,50L,50L))
	addComponent(rdsAttrDialog, networkPanel, vertPosition, 950, vertPosition+100, 600,
			topType="ABS",bottomType="NONE")
	
	network <- new(SingletonDJList)
	network$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	networkPanel$add(network)
	
	networkButton <- new(SingletonAddRemoveButton,c("add","remove"),
			c("add","remove"),network,varList$getList())
	networkButton$setPreferredSize(new(Dimension,36L,36L))
	addComponent(rdsAttrDialog, networkButton, vertPosition+15, 550, vertPosition+100, 482,
			topType="ABS",rightType="NONE",bottomType="NONE")
	
	subjCouponPanel <- new(JPanel)
	subjCouponPanel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Subject's Coupon"))
	subjCouponPanel$setLayout(new(J("java.awt.BorderLayout")))
	subjCouponPanel$setPreferredSize(new(Dimension,50L,50L))

	subjCoupon <- new(SingletonDJList)
	subjCoupon$setBorder(J("javax.swing.BorderFactory")$createBevelBorder(1L))
	subjCouponPanel$add(subjCoupon)
	
	subjCouponButton <- new(SingletonAddRemoveButton,c("add","remove"),
			c("add","remove"),subjCoupon,varList$getList())
	subjCouponButton$setPreferredSize(new(Dimension,36L,36L))
	
	couponList <- new(Deducer::ListWidget,"Coupons")

	couponButtons <- new(AddRemoveButtons,varList,couponList)
	couponButtons$setPreferredSize(new(Dimension,36L,80L))
	

	
	panel <- new(JPanel)
	panel$setBorder(J("javax.swing.BorderFactory")$createTitledBorder("Optional"))
	panel$setLayout(new(AnchorLayout))
	addComponent(rdsAttrDialog, panel, 550, 950, 900, 50)
	panel$setSize(405L,134L)
	
	couponNumLabel <- new(Deducer::JLabel,"Max # of Coupons:")
	couponNumLabel$setHorizontalAlignment(4L)
	addComponent(panel, couponNumLabel, 200, 400, 150, 10,topType="ABS",bottomType="NONE")
	
	couponNum <- new(Deducer::TextFieldWidget)
	couponNum$setTitle("couponNum")
	couponNum$setInteger(TRUE)
	couponNum$setLowerBound(1)
	addComponent(panel, couponNum, 180, 560, 230, 410,topType="ABS",bottomType="NONE")
	rdsAttrDialog$track(couponNum)
	
	popLabel <- new(Deducer::JLabel,"Population Size Estimate:")
	popLabel$setHorizontalAlignment(4L)
	addComponent(panel, popLabel, 600, 400, 150, 10,topType="ABS",bottomType="NONE")
	
	low <- new(Deducer::TextFieldWidget,"Low")
	low$setInteger(TRUE)
	low$setLowerBound(1)
	addComponent(panel, low, 400, 560, 200, 410,topType="ABS",bottomType="NONE")
	rdsAttrDialog$track(low)
	
	mid <- new(Deducer::TextFieldWidget,"Mid")
	mid$setInteger(TRUE)
	mid$setLowerBound(1)
	addComponent(panel, mid, 400, 720, 200, 570,topType="ABS",bottomType="NONE")
	rdsAttrDialog$track(mid)
	
	high <- new(Deducer::TextFieldWidget,"High")
	high$setInteger(TRUE)
	high$setLowerBound(1)
	addComponent(panel, high, 400, 880, 200, 730,topType="ABS",bottomType="NONE")
	rdsAttrDialog$track(high)
	
	notes <- new(Deducer::TextAreaWidget,"Notes")
	addComponent(panel, notes, 800, 990, 990, 10,topType="ABS")
	rdsAttrDialog$track(notes)
	
	checkFunc <- function(x){
		if(!couponFormat && recruiter$getModel()$getSize()==0L) return("Recruiter ID is required")
		if(network$getModel()$getSize()==0L) return("Subject network size is required")
		if(couponFormat){
			if(subjCoupon$getModel()$getSize()==0L) return("Subject's coupon must be defined")
			if(couponList$getModel()$getSize()==0L) return("Coupons must be defined")
		}
		''
	}
	rdsAttrDialog$setCheckFunction(toJava(checkFunc))
	
	runFuncRDS <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="")
		cmd <- ""
		dat <- dataName
		new.dat <- dataName
		
 		if(id$getModel()$getSize()==0L) {
		  lastID  <<- subj.id <- NULL
                }else{
		  lastID  <<- subj.id <- id$getModel()$getElementAt(0L)
                }
		lastRID <<- rec.id <- recruiter$getModel()$getElementAt(0L)
		lastNet <<- net <- network$getModel()$getElementAt(0L)
		coup <- couponNum$getModel()
		est.low <- low$getModel()
		est.mid <- mid$getModel()
		est.high <- high$getModel()
		not <- notes$getModel()
		not <- gsub("\\","\\\\",not,fixed=TRUE)
		not <- gsub("'","\\'",not,fixed=TRUE)
		
		if(coup == "") coup <- "NULL"
		if(est.low == "") est.low <- "NA"
		if(est.mid == "") est.mid <- "NA"
		if(est.high == "") est.high <- "NA"
		if(not == "") not <- "NULL" else not <- "'"%+%not%+%"'"
		
		cmd <- new.dat %+% " <- as.rds.data.frame("%+%dat%+%","
                if(id$getModel()$getSize()!=0L){
		 cmd <- cmd %+% " id='" %+% subj.id%+%"',"
                }
		cmd <- cmd %+%  " recruiter.id='" %+%rec.id %+%
				"'\n\t, network.size='" %+% net %+% 
				"', population.size=c("%+%est.low%+%","%+%est.mid%+%"," %+%est.high%+%")" %+%
				", max.coupons=" %+% coup %+%
				"\n\t, notes=" %+% not %+% ")\n" %+%
				new.dat %+% "$seed <- get.seed.id("%+%new.dat%+%")\n" %+%
				new.dat %+% "$wave <- get.wave("%+%new.dat%+%")"
		execute(cmd)
	}
	
	runFuncCoupon <- function(x){
		'%+%' <- function(x,y) paste(x,y,sep="")
		dat <- dataName
		new.dat <- dataName
		
 		if(id$getModel()$getSize()==0L) {
		  lastID  <<- subj.id <- NULL
                }else{
		  lastID  <<- subj.id <- id$getModel()$getElementAt(0L)
                }
		lastNet<<- net <- network$getModel()$getElementAt(0L)
		coup <- couponNum$getModel()
		est.low <- low$getModel()
		est.mid <- mid$getModel()
		est.high <- high$getModel()
		not <- notes$getModel()
		
		lastSCoup <<- subj.coupon <- subjCoupon$getModel()$getElementAt(0L)
		lastCoup <<- couponList$getItems()
		
                if(id$getModel()$getSize()==0L){
		 cmd1 <- new.dat %+% "$id <- 1:nrow(" %+% new.dat %+% ")\n"
                }else{
		 cmd1 <- NULL
                }
		cmd1 <- cmd1 %+% new.dat %+% "$recruiter.id <- rid.from.coupons(" %+% new.dat %+% ",\n"
                if(id$getModel()$getSize()!=0L){
		 cmd1 <- cmd1 %+% "\t subject.id='" %+% subj.id %+% "',"
                }
		cmd1 <- cmd1 %+% " subject.coupon='" %+% subj.coupon %+% 
				 "', coupon.variables=" %+% couponList$getRModel() %+% ")\n"
		
		rec.id <- "recruiter.id"
		
		if(coup == "") coup <- "NULL"
		if(est.low == "") est.low <- "NA"
		if(est.mid == "") est.mid <- "NA"
		if(est.high == "") est.high <- "NA"
		if(not == "") not <- "NULL" else not <- "'"%+%not%+%"'"
		
		cmd2 <- new.dat %+% " <- as.rds.data.frame("%+%new.dat %+% ","
                if(id$getModel()$getSize()!=0L){
		 cmd2 <- cmd2 %+% " id='" %+% subj.id %+% "',"
                }
		cmd2 <- cmd2 %+% " recruiter.id='" %+%rec.id %+%
				 "'\n\t, network.size='" %+% net %+% 
				 "', population.size=c("%+%est.low%+%","%+%est.mid%+%"," %+%est.high%+%")" %+%
				 ", max.coupons=" %+% coup %+%
				 "\n\t, notes=" %+% not %+% ")\n" %+%
				 new.dat %+% "$seed <- get.seed.id("%+%new.dat%+%")\n" %+%
				 new.dat %+% "$wave <- get.wave("%+%new.dat%+%")"
		execute(cmd1 %+% cmd2)
	}
	
	updateFormat()
	rdsAttrDialog
}















