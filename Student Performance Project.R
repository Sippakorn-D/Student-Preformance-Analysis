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

# Correlation test
cor.test(X1,Y)
cor.test(X2,Y)
cor.test(X3,Y)
cor.test(X4,Y)

# Make Model
model = lm(Y~X1+X2+X3+X4)
summary(model)
model.both <- step(model,direction = "both")
summary(model.both)

# Assumption Check
nortest::ad.test(model$residuals)
lmtest::dwtest(model)
lmtest::bgtest(model)
library(car)
vif(model)

# influential values
infl <- influence.measures(model)
influential_obs <- which(apply(infl$is.inf, 1, any))
length(influential_obs)
head(infl$infmat, 5)
data_cleaned <- StudentCleaned[-influential_obs, ]

# Make New Model
Y <- data_cleaned$`Performance Index`
X1_clean <- data_cleaned$`Hours Studied`
X2_clean <- data_cleaned$`Previous Scores`
X3_clean <- data_cleaned$`Sample Question Papers Practiced`
X4_clean <- data_cleaned$`Extracurricular Activities_Encoded`
model2 <- lm(Y_clean ~ X1_clean + X2_clean + X3_clean + X4_clean)
summary(model2)
model2.both <- step(model2,direction = "both")
summary(model2.both)

# Assumption Check one again
nortest::ad.test(model2$residuals)
lmtest::dwtest(model2)
lmtest::bgtest(model2)
vif(model2)

# Final influential values 
infl2 <- influence.measures(model2)
influential_obs <- which(apply(infl2$is.inf, 1, any))
length(influential_obs)
head(infl2$infmat, 5)
data_final <- StudentCleaned[-influential_obs, ]

# Make Final Model
Y_final <- data_final$`Performance Index`
X1_final <- data_final$`Hours Studied`
X2_final <- data_final$`Previous Scores`
X3_final <- data_final$`Sample Question Papers Practiced`
X4_final <- data_final$`Extracurricular Activities_Encoded`
model_final <- lm(Y_final ~ X1_final + X2_final + X3_final + X4_final)
summary(model_final)
model_final.both <- step(model_final,direction = "both")
summary(model_final.both)

# Assumption Final Check
nortest::ad.test(model_final$residuals)
lmtest::dwtest(model_final)
lmtest::bgtest(model_final)
vif(model_final)

# Appropriate model
library(leaps)
model_data <- data.frame(Y = Y_final, X1 = X1_final, X2 = X2_final, X3 = X3_final, X4 = X4_final)
models <- list(
  lm(Y ~ X1, data = model_data),
  lm(Y ~ X2, data = model_data),
  lm(Y ~ X3, data = model_data),
  lm(Y ~ X4, data = model_data),
  lm(Y ~ X1 + X2, data = model_data),
  lm(Y ~ X1 + X3, data = model_data),
  lm(Y ~ X1 + X4, data = model_data),
  lm(Y ~ X2 + X3, data = model_data),
  lm(Y ~ X2 + X4, data = model_data),
  lm(Y ~ X3 + X4, data = model_data),
  lm(Y ~ X1 + X2 + X3, data = model_data),
  lm(Y ~ X1 + X2 + X4, data = model_data),
  lm(Y ~ X1 + X3 + X4, data = model_data),
  lm(Y ~ X2 + X3 + X4, data = model_data),
  lm(Y ~ X1 + X2 + X3 + X4, data = model_data)
)

#evaluate function
evaluate_model <- function(model){
       y <- model$model$Y
       y_hat <- predict(model)
       MSE <- mean((y - y_hat)^2)
       R2 <- summary(model)$r.squared
       R2_adj <- summary(model)$adj.r.squared
       Cp <- sum((residuals(model))^2) / summary(model)$sigma^2 - length(coef(model)) + 2
       PRESS <- sum(residuals(model)^2 / (1 - hatvalues(model))^2)
       
         return(c(MSE, R2, R2_adj, Cp, PRESS))
}

#evaluate model
results <- t(sapply(models, evaluate_model))
colnames(results) <- c("MSE", "R²", "R²_adj", "Cp", "PRESS")
results <- round(results, 15)

#table summary
model_names <- c("X1","X2","X3","X4","X1, X2","X1, X3","X1, X4","X2, X3","X2, X4","X3, X4", "X1, X2, X3","X1, X2, X4","X1, X3, X4","X2, X3, X4", "X1, X2, X3, X4")
final_table <- data.frame(Model = 1:15, Variables = model_names, results)

print(final_table)

#plot model 
plot(model)
