# import Data set
library(readxl)
StudentCleaned <- 
read_excel("C:/Users/Windows 10/OneDrive/Desktop/Coding/Python/Regression Project/Student Performance/StudentCleaned.xlsx")
View(StudentCleaned)

# Setting Variables
Y = StudentCleaned$'Performance Index'
X1 = StudentCleaned$'Hours Studied'
X2 = StudentCleaned$'Previous Scores'
X3 = StudentCleaned$'Sample Question Papers Practiced'
X4 = StudentCleaned$'Extracurricular Activities_Encoded'

# Correration test
cor.test(X1,Y)
cor.test(X2,Y)
cor.test(X3,Y)
cor.test(X4,Y)

# Make Model
model = lm(Y~X1+X2+X3+X4)
summary(model)

# Assumption Check
nortest::ad.test(Y)
lmtest::dwtest(model)
lmtest::bgtest(model)

#Fix Independent
hist(Y); qqnorm(Y); qqline(Y)
library(MASS); bc = boxcox(lm(Y ~ 1))
lambda = bc$x[which.max(bc$y)]
Y_bc = if(lambda==0) log(Y) else (Y^lambda-1)/lambda

# Independent Check
model = lm(Y_bc ~ X1 + X2 + X3 + X4)
summary(model)
qqnorm(residuals(model)); qqline(residuals(model))
nortest::ad.test(residuals(model))

#Multiple Assumptions
library(car)
vif(model)

#Powerful Value
influence.measures(model)

# Appropriate model
library(leaps)
data = data.frame(Y, X1, X2, X3, X4)
models <- list(
       lm(Y ~ X1, data = data),
       lm(Y ~ X2, data = data),
       lm(Y ~ X3, data = data),
       lm(Y ~ X4, data = data),
       lm(Y ~ X1 + X2, data = data),
       lm(Y ~ X1 + X3, data = data),
       lm(Y ~ X1 + X4, data = data),
       lm(Y ~ X2 + X3, data = data),
       lm(Y ~ X2 + X4, data = data),
       lm(Y ~ X3 + X4, data = data),
       lm(Y ~ X1 + X2 + X3, data = data),
       lm(Y ~ X1 + X2 + X4, data = data),
       lm(Y ~ X1 + X3 + X4, data = data),
       lm(Y ~ X2 + X3 + X4, data = data),
       lm(Y ~ X1 + X2 + X3 + X4, data = data)
)
evaluate_model <- function(model) {
       y <- model$model$Y
       y_hat <- predict(model)
       MSE <- mean((y - y_hat)^2)
       R2 <- summary(model)$r.squared
       R2_adj <- summary(model)$adj.r.squared
       Cp <- sum((residuals(model))^2) / summary(model)$sigma^2 - length(coef(model)) + 2
       PRESS <- sum(residuals(model)^2 / (1 - hatvalues(model))^2)
       
         return(c(MSE, R2, R2_adj, Cp, PRESS))
}

results <- t(sapply(models, evaluate_model))
colnames(results) <- c("MSE", "R²", "R²_adj", "Cp", "PRESS")
results <- round(results, 15)

model_names <- c("X1","X2","X3","X4","X1, X2","X1, X3","X1, X4","X2, X3","X2, X4","X3, X4", "X1, X2, X3","X1, X2, X4","X1, X3, X4","X2, X3, X4", "X1, X2, X3, X4")
final_table <- data.frame(Model = 1:15, Variables = model_names, results)
print(final_table)

model.both <- step(model,direction = "both")
summary(model.both)