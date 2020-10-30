#!/usr/bin/env Rscript
library(PredictABEL)


# NOT RUN {
# specify dataset with outcome and predictor variables
data(ExampleData) 
# specify column numbers of genetic predictors
cGenPred <- c(11:16)


# fit a logistic regression model
# all steps needed to construct a logistic regression model are written in a function
# called 'ExampleModels', which is described on page 4-5
riskmodel <- ExampleModels()$riskModel2


# compute unweighted risk scores 
riskScore <- riskScore(weights=riskmodel, data=ExampleData, 
cGenPreds=cGenPred, Type="unweighted")



# specify dataset with outcome and predictor variables
data(ExampleData)
# specify column number of the outcome variable
cOutcome <- 2

# fit a logistic regression model
# all steps needed to construct a logistic regression model are written in a function
# called 'ExampleModels', which is described on page 4-5
riskmodel <- ExampleModels()$riskModel2

# obtain predicted risks
predRisk <- predRisk(riskmodel)

# specify the size of each interval
interval <- .05
# specify label of x-axis
xlabel <- "Predicted risk"
# specify label of y-axis
ylabel <- "Percentage"
# specify range of x-axis
xrange <- c(0,1)
# specify range of y-axis
yrange <- c(0,40)
# specify title for the plot
maintitle <- "Distribution of predicted risks"
# specify labels
labels <- c("Without outcome", "With outcome")

# produce risk distribution plot
plotRiskDistribution(data=ExampleData, cOutcome=cOutcome,
risks=predRisk, interval=interval, plottitle=maintitle, rangexaxis=xrange,
rangeyaxis=yrange, xlabel=xlabel, ylabel=ylabel, labels=labels)




data(ExampleData)

# fit logistic regression models
# all steps needed to construct a logistic regression model are written in a function
# called 'ExampleModels', which is described on page 4-5
riskmodel1 <- ExampleModels()$riskModel1
riskmodel2 <- ExampleModels()$riskModel2

# obtain predicted risks
predRisk1 <- predRisk(riskmodel1)
predRisk2 <- predRisk(riskmodel2)

# specify range of y-axis
rangeyaxis <- c(0,1) 
# specify labels of the predictiveness curves
labels <- c("without genetic factors", "with genetic factors")

# produce predictiveness curves
plotPredictivenessCurve(predrisk=cbind(predRisk1,predRisk2),
rangeyaxis=rangeyaxis, labels=labels)




# specify the matrix containing the ORs and frequencies of genetic variants 
# In this example we used per allele effects of the risk variants
ORfreq<-cbind(c(1.35,1.20,1.24,1.16), rep(1,4), c(.41,.29,.28,.51),rep(1,4))

# specify the population disease risk
popRisk <- 0.3
# specify size of hypothetical population
popSize <- 10000

# Obtain the simulated dataset
Data <- simulatedDataset(ORfreq=ORfreq, poprisk=popRisk, popsize=popSize)

# Obtain the AUC and produce ROC curve
plotROC(data=Data, cOutcome=4, predrisk=Data[,3])




# specify dataset with outcome and predictor variables
data(ExampleData)

# fit a logistic regression  model
# all steps needed to construct a logistic regression model are written in a function
# called 'ExampleModels', which is described on page 4-5
riskmodel <- ExampleModels()$riskModel2

# obtain predicted risks
predRisk <- predRisk(riskmodel)

# specify column numbers of genetic predictors
cGenPred <- c(11:16)

# function to compute unweighted genetic risk scores
riskScore <- riskScore(weights=riskmodel, data=ExampleData, 
cGenPreds=cGenPred, Type="unweighted")

# specify range of x-axis
rangexaxis <- c(0,12)   
# specify range of y-axis
rangeyaxis <- c(0,1)     
# specify label of x-axis
xlabel <- "Risk score"     
# specify label of y-axis
ylabel <- "Predicted risk" 
# specify title for the plot
plottitle <- "Risk score versus predicted risk"

# produce risk score-predicted risk plot
plotRiskscorePredrisk(data=ExampleData, riskScore=riskScore, predRisk=predRisk, 
plottitle=plottitle, xlabel=xlabel, ylabel=ylabel, rangexaxis=rangexaxis, 
rangeyaxis=rangeyaxis)


