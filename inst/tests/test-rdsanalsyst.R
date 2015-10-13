# TODO: 
# 
# Author: JaneAc

# run using test_file() and the location of this file
###############################################################################

#if (!"testthat" %in% rownames(installed.packages())) {install.packages("testthat")}
#library("testthat")
#library("DeducerRDSAnalyst")
#data(faux) # Some tests are written for faux data set. 
#temp_test_rdsanalyst =  0 #temp variable with safe name for use below
#
## Allow user to set it to test specific data set?
#
#context("rdsa_compute_weights") #note, this function is from RDSdevelopment package
#
#test_that("First weight of faux data set", {
#			
#		expect_that(round(compute_weights(faux, weight.type="Gile's SS",N=10000)[1],5),
#		is_equivalent_to(23.90475))
#		expect_that(round(compute_weights(faux)[1]),equals(2)) #fluctuates around 2.4
#	})
#
#
#test_that("Compute weights required inputs", {
#			
#			expect_error(compute_weights(),"Error.+")
#			expect_error(compute_weights(faux,weight.type="Gile's SS",N=""),"Error.+")
#		})
#
#context("rdsa_contingency_tables")
#
#test_that("Contingency tables output",  {
#			
#			expect_output(wtd.contingency.tables(X,Y,data=faux),"blue.+red")
#			expect_output(wtd.contingency.tables(X,Y,data=faux),levels(faux$X))
#			expect_output(wtd.contingency.tables(X,Y,data=faux),levels(faux$Y))
#			expect_output(wtd.contingency.tables(X,Y,data=faux),"Count.+Row.+Column.+Total")
#			expect_output(wtd.contingency.tables(d(X,wave),Y,data=faux),"Table.+Count.+Row.+Column.+Table")
#			
#		})
#
#test_that("Contingency tables inputs",  {
#			
#			expect_error(wtd.contingency.tables(data=data_default),"Error")
#			expect_error(wtd.contingency.tables(Y,data=faux),"Error")
#			
#		})
#			
#context("descriptives")
#
#test_that("Descriptives function input", {
#			
#			expect_error(descriptive.table(data= faux, func.names =c("Mean")),"Error")
#			expect_warning(descriptive.table( faux$X,faux$wave,faux),"Non-numeric")
#			
#		})
#			
#
#test_that("Descriptives function output", {
#			
#			expect_output(descriptive.table(vars = d(network.size),data= faux, 
#							func.names =c("Mean","St. Deviation","Valid N")),".+Mean.network.size")
#			expect_output(descriptive.table(vars = d(network.size) ,
#							strata = d(wave),data= faux, func.names =c("Mean","St. Deviation","Median","25th Percentile")),"wave.+Mean.network.size.+Percentile")
#			expect_output(descriptive.table(vars = d(network.size),data= faux,
#					func.names =c("Minimum","Maximum")),"4.+43") 
#			
#		})
#
#
#context("differential-activity")
#
#test_that("differential activity input", {
#			
#			expect_warning(differential.activity.estimates(faux, outcome.variable=c("network.size","wave"),
#					weight.type="RDS-II", uncertainty="RDS-II", N=10000, number.ss.samples.per.iteration=1000, 
#					subset= network.size<10), "This is not a valid rds")		
#			expect_error(differential.activity.estimates(outcome.variable=c("network.size","wave"),
#					weight.type="RDS-II", uncertainty="RDS-II", N=10000), "Error")	
#	
#		})	
#
#test_that("differential activity output", {
#			
#			expect_output(differential.activity.estimates(faux, outcome.variable=c("X"),
#					weight.type="Gile's SS", uncertainty="Gile's SS", N=10000, number.ss.samples.per.iteration=1000), "mean degree of those with value 1")
#			expect_output(differential.activity.estimates(faux, outcome.variable=c("network.size"), 
#					weight.type="RDS-I", uncertainty="RDS-I", N=10000, number.ss.samples.per.iteration=1000), "mean degree")
#			expect_output(differential.activity.estimates(faux, outcome.variable=c("network.size","wave"), 
#					weight.type="RDS-II", uncertainty="RDS-II", N=10000, number.ss.samples.per.iteration=1000),"mean degree.+mean degree")
#		
#		})
#
#context("frequencies")
#
#test_that("frequencies input", {
#			
#			expect_error(frequencies(,r.digits = 1),"argument \"data\" is missing")
#			
#			
#		})	
#
#test_that("frequencies output", {
#			
#			expect_output(frequencies(faux[c("X")] , r.digits = 1),"Frequencies.+Case Summary")
#			expect_output(frequencies(faux[c("X","wave")] , r.digits = 1),"Cumulative.+Total")
#		})
#
#context("homophily")
#
#test_that("Population homophily input", {
#			
#			expect_error(homophily.estimates(outcome.variable=c("wave"), recruitment=FALSE, N=1000),"Error")
#			expect_error(homophily.estimates(rds.data=faux, outcome.variable=wave, recruitment=FALSE, N=1000),"Error")
#			expect_error(homophily.estimates(rds.data=faux, outcome.variable=c("wave"), recruitment=FALSE, N="1000"),"Error")			
#		})	
#
#test_that("Population homophily output", {
#			
#		expect_output(homophily.estimates(rds.data=faux, outcome.variable=c("wave"), recruitment=FALSE, N=1000),"Population Homophily Estimate for wave")
#		expect_output(homophily.estimates(rds.data=faux, outcome.variable=c("wave","X"), recruitment=FALSE, N=1000),"Population Homophily Estimate for wave.+Population Homophily")
#		expect_output(homophily.estimates(rds.data=faux, outcome.variable=c("wave","X"), N=1000),"Population Homophily Estimate for wave.+Population Homophily")
#		})
#
#
#context("meta-data") 
##Note: this function currently has a bug with subject id field
##postpone writing tests until fixed
#
#context("plot") #for Recruitment Diagnostic in Plots menu
#				#also try from dialogues to test pdf save function
##test_that("Recruitment Diagnostics plot error", {
##			
##		#these take a while	
##		plot.rds.diagnostics(faux, plot.type='Network size by wave')	
##		expect_output(dev.list(),"JavaGD")
##		dev.off()
##		
##		plot.rds.diagnostics(faux, plot.type='Recruitment tree')	
##		expect_output(dev.list(),"JavaGD")
##		dev.off()
##		
##		plot.rds.diagnostics(faux, plot.type='Recruits by wave')	
##		expect_output(dev.list(),"JavaGD")
##		dev.off()
##		
##		plot.rds.diagnostics(faux, plot.type='Recruits per seed')	
##		expect_output(dev.list(),"JavaGD")
##		dev.off()
##		
##		plot.rds.diagnostics(faux, plot.type='Recruits per subject')	
##		expect_output(dev.list(),"JavaGD")
##		dev.off()
##		
##		})
#
#context("plotrecruitment") #currently broken. 
##This WILL return an error and needs to be updated.
#
##test_that("Plot Recruitment Tree error", {
##			
##			plot_recruitment_tilford(faux)	
##			expect_output(dev.list(),"JavaGD")
##			dev.off()
##		})		
#
##context("testdiffproportions") -- I couldn't get this to work with the faux data - is it working? Needs more explanation in the dialogue.
#
##context("save-data") 
##context("savevna")
##not sure how to test save functions without writing to user files.
##Should be divide into a larger set of tests for our use and tests for users?
#
#
#
#context("load-data")
#
#test_that("load-data input", {
#			
#			expect_error
#			
#		})	
#
#test_that("load-data output", {
#			
#			expect_output})

