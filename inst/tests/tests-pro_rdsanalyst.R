# TODO: Add comment
# 
# Author: JaneAc
###############################################################################


if (!"testthat" %in% rownames(installed.packages())) {install.packages("testthat")}
library("testthat")
library("DeducerRDSAnalyst")
data(faux) # Some tests are written for faux data set. 
temp_test_rdsanalyst =  0 #temp variable with safe name for use below

# Allow user to set it to test specific data set?

context("RDS Population Frequency Estiamtes") 


		#erase when completed "~/Documents/workspace/rdsdev/rdsworkinggroup/software/DeducerRDSAnalyst/inst/tests/tests-pro_rdsanalyst.R"