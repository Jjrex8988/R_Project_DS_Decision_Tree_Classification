# Decision Tree Classification

# Importing the dataset
dataset <- read.csv('Churn_Modelling.csv')
dataset <- dataset[4:14]


# Encoding the target feature as factor
dataset$Exited <- factor(dataset$Exited, levels = c(0, 1))

dataset$Geography <- as.numeric(factor(dataset$Geography,
                                      levels = c('France', 'Spain', 'Germany'),
                                      labels = c(1, 2, 3)))

dataset$Gender <- as.numeric(factor(dataset$Gender,
                                   levels = c('Female', 'Male'),
                                   labels = c(1, 2)))


# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split <- sample.split(dataset$Exited, SplitRatio = 0.8)

training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)


# Feature Scaling
training_set[-11] <- scale(training_set[-11])
test_set[-11] <- scale(test_set[-11])


# Applying LDA
library(MASS)
lda = lda(formula = Exited ~ ., data = training_set)
training_set = as.data.frame(predict(lda, training_set))
training_set = training_set[c(4, 1)]
test_set = as.data.frame(predict(lda, test_set))
test_set = test_set[c(4, 1)]


# Fitting Decision Tree Classification to the Training set
# install.packages('rpart')
library(rpart)
classifier <- rpart(formula = class ~.,
                    data = training_set)


# Predicting the Test set results
# y_pred = predict(classifier, newdata = test_set[-3])
y_pred = predict(classifier, newdata = test_set[-2], type = 'class')


# Making the Confusion Matrix
cm <- table(test_set[, 2], y_pred)


# Visualising the Training set results
library(ElemStatLearn)
set = training_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('x.LD1', 'x.LD2')
y_grid = predict(classifier, newdata = grid_set)
plot(set[, -3],
     main = 'Decision Tree Classification (Training set)',
     xlab = 'LD1', ylab = 'LD2',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 2, 'deepskyblue', ifelse(y_grid == 1, 'springgreen3', 'tomato')))
points(set, pch = 21, bg = ifelse(set[, 3] == 2, 'blue3', ifelse(set[, 3] == 1, 'green4', 'red3')))


# Visualising the Test set results
library(ElemStatLearn)
set = test_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('x.LD1', 'x.LD2')
y_grid = predict(classifier, newdata = grid_set)
plot(set[, -3], main = 'Decision Tree Classification (Test set)',
     xlab = 'LD1', ylab = 'LD2',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 2, 'deepskyblue', ifelse(y_grid == 1, 'springgreen3', 'tomato')))
points(set, pch = 21, bg = ifelse(set[, 3] == 2, 'blue3', ifelse(set[, 3] == 1, 'green4', 'red3')))







