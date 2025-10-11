# Student-Performance-Analysis  

I have some project that my professor in Regression & Correlation Analysis has told to find some Dataset to Forecasting and Application Knowledge. So that i'm Decide to Predict Performance Index from 10K Student  

## About
The Student Performance Dataset is a dataset designed to examine the factors influencing academic student performance. The dataset consists of 10,000 student records, with each record containing information about various predictors and a performance index.

### Variables
* Hours Studied: The total number of hours spent studying by each student.  
* Previous Scores: The scores obtained by students in previous tests.  
* Extracurricular Activities: Whether the student participates in extracurricular activities (Yes or No).  
* Sample Question Papers Practiced: The number of sample question papers the student practiced.  

### Target Variable
* Performance Index: A measure of the overall performance of each student. The performance index represents the student's academic performance and has been rounded to the nearest integer. The index ranges from 10 to 100, with higher values indicating better performance.

Resources: https://www.kaggle.com/datasets/nikhil7280/student-performance-multiple-linear-regression

## Analysis Process

### First step : Preparation raw data to Analysis (With Python)  
1) EDA Dataset
2) Cleansing Missing Value & Outlier
3) Add dummy Variable
4) Svae Cleaned Data

### Seccond step : Analysis by Multiple Regression (With R)
1) Before Build Model
* Linearlity Check : By Correlation
* VIF (Overfit Checking)

2) Building Model
* Build Multiple Regression
* influence Check and Delete
* Select The Best Model with MSE , R-Square , R-Square ADJ , Cp , PRESS
* Select The Best Model with Stepwise Regression Method

3) After Builded Model
* Independent Check : By Anderson-Darling Test
* Normality Check : By Durbin-Watson Test
* Equality Check : By Breusch-Pagan Test

### Final step : Summary result  

Poster :
