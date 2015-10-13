# TODO: Add comment
# 
# Author: JaneAc
# Contains: Tests of basic functions
###############################################################################


if (!"testthat" %in% rownames(installed.packages())) {install.packages("testthat")}
library("testthat")
library("DeducerRDSAnalyst")
data(faux) # Some tests are written for faux data set. 
temp_test_rdsanalyst =  0 #temp variable with safe name for use below

# Allow user to set it to test specific data set?

context("Data: Recode Variables") #note, this function is from RDSdevelopment package

test_that("Define Recode", {
			
			expect_output(faux[c("X1","network3")] <- recode.variables(faux[c("X","network.size")] , "7 -> 8;"), "")
			expect_output(faux[c("network.size")] <- recode.variables(faux[c("network.size")] , "10:20 -> 15;"),"")
		
		})

context("Analysis: Descriptives")

test_that("Descriptives inputs", {
			
			expect_warning(descriptive.table(vars = d(X),data= faux, func.names =c("Mean")),"Non-numeric variables")
			#Line above might change to an error instead of a warning
			
		})

test_that("Descriptives outputs", {
			
			expect_output(descriptive.table(vars = d(network.size),data= faux, func.names =c("Mean")),"Mean.network.size")
			
		})



