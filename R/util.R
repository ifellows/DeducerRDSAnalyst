#' Weighted frequencies
#' @param data A data.frame of discrete variables.
#' @param weights The weights
#' @param r.digits The number of significant digits to display
#' @export
wtd.frequencies<-function(data,weights=NULL,r.digits=1){
	if(is.null(weights))
		stop("please specify weights")
	frequencies.var<-function(variable, weights){
		freq<-Hmisc::wtd.table(x=variable,weights=weights,type="table")
		freq<-data.frame(Value=names(freq), Freq=freq)
		freq$Percentage<-round(freq$Freq/sum(freq$Freq)*100,digits=r.digits)
		freq$Cum.Percentage<-round(cumsum(freq$Freq)/sum(freq$Freq)*100,digits=r.digits)
		
		if(var(weights, na.rm=TRUE)>0){
			num.miss<-matrix(0,nrow=2,ncol=3)
			row.names(num.miss)<-c("# of cases","weighted # of cases")
			num.miss[1,]<-c(sum(!is.na(variable)),sum(is.na(variable)),length(variable))
			num.miss[2,]<-c(sum(weights[!is.na(variable)]),sum(weights[is.na(variable)]),sum(weights))
		}else{
			num.miss<-matrix(0,nrow=1,ncol=3)
			colnames(num.miss)<-c("Valid","Missing","Total")
			row.names(num.miss)<-"# of cases"
			num.miss[1,]<-c(sum(weights[!is.na(variable)]),sum(weights[is.na(variable)]),sum(weights))
		}
		colnames(num.miss)<-c("Valid","Missing","Total")
		
		colnames(freq)<-c("Value","# of Cases","      %","Cumulative %")
		result<-list(Frequencies=freq,case.summary=num.miss)
		class(result)<-"freq.table"
		return(result)
	}
	if(!is.data.frame(data)){
		data<-as.data.frame(data)
	}
	
	if(length(weights)!=nrow(data)){
		weights <- rep(1,nrow(data))
	}
	
	results<-list()
	
	for(index in 1:dim(data)[2]){
		results[[names(data)[index]]]<-frequencies.var(data[,index],weights)
	}
	class(results)<-"freq.table"
	return(results)
}




#' Weighted descriptives
#' @param vars The variables
#' @param strata The stratifying variables
#' @param data A data.frame
#' @param func.names The descriptive statistics to calculate
#' @param weights The weights
#' @param subset A logical expression for subsetting
#' @export
wtd.descriptive.table<-function(vars,strata,data,func.names = c("Mean","St. Deviation","Median",
				"25th Percentile","75th Percentile",
				"Minimum","Maximum","Population Size"),weights,subset=NULL){
	subset <- eval(substitute(subset),data,parent.frame())
	if(!is.null(subset))
		stop("subset not yet implemented")
	
	dat<-eval(substitute(vars),data, parent.frame())
	if(length(dim(dat))<1.5)
		dat<-d(dat)
	if(any(!sapply(dat,is.numeric))){
		dat<-dat[sapply(dat,is.numeric)]
		warning("Non-numeric variables dropped from descriptive table")
	}
	if(missing(strata)){
		strata<-rep("all cases",dim(dat)[1])
	}else{
		strata<-eval(substitute(strata),data, parent.frame())
		if(length(dim(strata))<1.5)
			strata<-d(strata)
	}
	dat$wts <- weights
	if(!all(sapply(dat,is.numeric))) stop("Descriptives can only be run on numeric variables")
	func.indexes <- pmatch(func.names, c("Mean","St. Deviation","Median","25th Percentile",
					"75th Percentile","Minimum","Maximum","Population Size"))
	#TODO: are these good estimates of min and max?
	functions<-c(	function(x,weights) Hmisc::wtd.mean(x=x,weight=weights,na.rm=TRUE),
			function(x,weights) sqrt(Hmisc::wtd.var(x=x,weights=weights,na.rm=TRUE,normwt=TRUE)),
			function(x,weights) Hmisc::wtd.quantile(x=x,weights=weights,probs=0.5,na.rm=TRUE,normwt=TRUE),
			function(x,weights) Hmisc::wtd.quantile(x,weights,probs=.25,na.rm=TRUE,normwt=TRUE),
			function(x,weights) Hmisc::wtd.quantile(x,weights,probs=.75,na.rm=TRUE,normwt=TRUE),
			function(x,weights) min(x,na.rm=TRUE),
			function(x,weights) max(x,na.rm=TRUE),
			function(x,weights) sum(weights[!is.na(x)])
	)
	functions<-functions[func.indexes]
	
	##calculate statistics
	tbl.list<-list()
	for(ind in 1:length(functions)){
		tbl.list[[func.names[ind]]]<-by(dat, strata, 
				function(x) sapply(x[,-ncol(x),drop=FALSE], function(y) functions[[ind]](y,x$wts)) ,simplify=FALSE)
	}
	##format into table
	result<-list()
	for(ind in 1:length(tbl.list[[1]])){
		d <- dim(tbl.list[[1]])
		dn <- dimnames(tbl.list[[1]])
		dnn <- names(dn)
		ii <- ind - 1
		name<-""
		for (j in seq_along(dn)) {
			iii <- ii%%d[j] + 1
			ii <- ii%/%d[j]
			name <- paste(name,dnn[j], ": ", dn[[j]][iii], " ", sep = "")
		}		
		result[[name]]<-sapply(tbl.list,function(x) x[[ind]])
	}
	
	##clean out nulls
	result<-result[!sapply(result,function(x)all(sapply(x,function(x)all(is.null(x)))))]
	return(result)
}

#' Weighted Contingency Tables
#' @param row.vars Row variables.
#' @param col.vars Column variables.
#' @param stratum.var A varaible to stratify by.
#' @param weights Sampling weights.
#' @param data A data.frame.
#' @param missing.include Include missing values as a level.
#' @param subset A subset expression.
#' @export
wtd.contingency.tables<-function (row.vars, col.vars, stratum.var, weights=NULL, data=NULL, 
		missing.include=FALSE,subset=NULL) {
	subset <- eval(substitute(subset),data,parent.frame())
	if(!is.null(subset))
		stop("subset not yet implemented")	
	arguments <- as.list(match.call()[-1])
	if(missing(row.vars) || missing(col.vars))
		stop("Please specify the row variables (row.vars), and column variables (col.vars)")
	row.vars <- eval(substitute(row.vars),data, parent.frame())
	col.vars <- eval(substitute(col.vars),data, parent.frame())
	if(length(dim(row.vars))<1.5){
		row.vars <- as.data.frame(row.vars)
		names(row.vars) <- as.character(arguments$row.vars)
	}
	if(length(dim(col.vars))<1.5){
		col.vars<-as.data.frame(col.vars)
		names(col.vars) <- as.character(arguments$col.vars)
	}
	
	#print(row.vars)
	if(!missing(stratum.var))
		stratum.var<-eval(substitute(stratum.var),data, parent.frame())
	else
		stratum.var<-NULL
	vector.x <- FALSE
	num.row.vars<-dim(row.vars)[2]
	num.col.vars<-dim(col.vars)[2]
	
	if(!is.null(weights)){
		weights<-eval(substitute(weights),data, parent.frame())
	}else{
		weights <- rep(1,nrow(data))
	}
	
	##takes a dataframe whose first two column are the row and column vectors for the table.
	##optionally a third column indicates stratum
	single.table<-function(dat,dnn,weights){
		x<-dat[[1]]
		y<-dat[[2]]
		if(is.null(stratum.var))
			stratum.var<-rep("No Strata",length(x))
		if (length(x) != length(y)) 
			stop("all row.vars and col.vars must have the same length")
		if (missing.include) {
			x <- factor(x, exclude = c())
			y <- factor(y, exclude = c())
			strata <- factor(stratum.var, exclude = c())
		}
		else {
			x <- factor(x)
			y <- factor(y)
			strata <- factor(stratum.var)
		}
		lev<-levels(strata)
		table.list<-list()
		for(level in lev){
			temp.x<-x[strata==level]
			temp.y<-y[strata==level]
			temp.w<-weights[strata==level]
			t <- xtabs(temp.w ~ temp.x + temp.y)
			names(dimnames(t)) <- dnn
			CPR <- prop.table(t, 1)
			CPC <- prop.table(t, 2)
			CPT <- prop.table(t)
			RS <- round(rowSums(t),2) #round
			CS <- round(colSums(t),2) #round
			t<-t[RS>0,CS>0,drop=FALSE]
			RS <- round(rowSums(t),2) #round
			CS <- round(colSums(t),2) #round
			CST <- try(suppressWarnings(chisq.test(t, correct = FALSE)),silent=TRUE)
			if(class(CST)!="htest")
				CST<-list(expected=t*NA)
			GT <- sum(t)
			if (length(dim(x) == 2)) 
				TotalN <- GT
			else TotalN <- length(temp.x)
			table.list[[level]]<-list(table=round(t,1), #round
					row.sums=RS,col.sums=CS,
					total=GT,row.prop=CPR,col.prop=CPC,total.prop=CPT,
					expected=CST$expected)
			class(table.list[[level]])<-"single.table"
		}
		class(table.list)<-"contin.table"
		table.list
	}
	result<-list()
	count<-1;
	for(i in 1:num.row.vars){
		for(j in 1:num.col.vars){
			result[[paste(names(row.vars)[i],"by",names(col.vars)[j])]]<-single.table(
					data.frame(row.vars[,i],col.vars[,j]),
					dnn=c(names(row.vars)[i],names(col.vars)[j]),
					weights=weights)
			count<-count+1
		}
	}
	class(result)<-"contingency.tables"
	attr(result, "rowNames") = paste(as.character(arguments$row.vars), 
			collapse = ", ")
	attr(result, "colNames") = paste(as.character(arguments$col.vars), 
			collapse = ", ")
	if(!missing(stratum.var))
		attr(result, "strata.name") = as.character(arguments$stratum.var)
	result
}

#' Initializes a list of estimates
#' @export
listOfRDSEstimates <- function(){
  vlist <- objects(pos=1)
  vlist <- vlist[sapply(vlist,function(x){is.rds.interval.estimate(get(x))})]
#
  sd <- matrix(0,nrow=2,ncol=length(vlist))
  rownames(sd) <- c("estimate","sigma")
  colnames(sd) <- vlist
  if(length(vlist)>0){
  for(i in seq_along(vlist)){
	x <- get(vlist[i])
	matest <- matrix(x$interval, ncol = 6, byrow = FALSE)
	if (nrow(matest) > 1) {
		rownames(matest) <- names(x$interval)[1:nrow(matest)]
	} else {
		rownames(matest) <- x$outcome.variable
		names(x$interval) <- rep(x$outcome.variable, length(x$interval))
	}
	rownames(matest)[is.na(rownames(matest))] <- "NA"
	mnames <- max(nchar(names(x$interval)[1:nrow(matest)]))
	colnames(matest) <- c("point", "lower", "upper", "Design Effect", "s.e.", "n")
	sd[1,i] <- matest[nrow(matest),1]
	sd[2,i] <- matest[nrow(matest),5]
	f=sub("_c..","_",colnames(sd)[i],fixed=TRUE)
	locdotdot <- regexpr("..",f,fixed=TRUE)
	if(locdotdot>0){colnames(sd)[i] <- substr(f,1,locdotdot-1)}
  }}
  sd <- as.data.frame(sd)
#
  attr(sd,"variables") <- vlist
  class(sd) <- c('rds.interval.estimate.list','data.frame')
  invisible(sd)
}

#' Safely Trim whitespace from start and end of string.
#' @param x input character vector
#' @return character vector with leading and trailing whitespace removed
#' @details This is a version of str_tirm from the stringr package that returns its argument when the argument is not a string.
#' @seealso str_trim
#' @export
save_str_trim <- function(x){if(is.character(x)){str_trim(x)}else{x}}
