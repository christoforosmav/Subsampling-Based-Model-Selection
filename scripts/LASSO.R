######################################### LASSO
library(glmnet)

file_X <- file.choose()
file_Y <- file.choose()

X <- read.csv(file_X)
Xnew <- X[, !colnames(X) %in% c("X50","X63")] #Excluded after VIF filtering
x1=scale(Xnew)
Y <- unlist(read.csv(file_Y))
y1=scale(Y)
lasso_model <- cv.glmnet(x = as.matrix(x1), y = y1, alpha = 1)


best_lambda <- lasso_model$lambda.min
cat("Optimal Lambda:", best_lambda, "\n")

lasso_coefs <- coef(lasso_model, s = best_lambda)
nonzero_predictors <- rownames(lasso_coefs)[lasso_coefs[, 1] != 0]

cat("Predictors with non-zero coefficients:\n")
cat(nonzero_predictors, "\n")
lasso_coefs

########################################################SUBSAMPLE LASSO
library(glmnet)
file_X <- file.choose()
file_Y <- file.choose()
X <- read.csv(file_X)
Xnew <- X[, !colnames(X) %in% c("X50","X63")]
x1=scale(Xnew)
Y <- unlist(read.csv(file_Y))
y1=scale(Y)
B <- 200
n <- nrow(x1)
p <- ncol(x1)
lambda_valuesa <- numeric(B)
coefficients_matrixa <- matrix(NA, nrow = p, ncol = B)

for (k in 1:B) {
  
  subsample_index <- sample(1:n, size = floor(0.632 * n), replace = FALSE)
  
  
  X_subsample <- as.matrix(x1[subsample_index, ])
  Y_subsample <- as.numeric(y1[subsample_index])
  
  
  lasso_model <- cv.glmnet(X_subsample, Y_subsample, alpha = 1)
  
  
  lambda_valuesa[k] <- lasso_model$lambda.min
  
  
  coefficients_matrixa[, k] <- coef(lasso_model, s = lasso_model$lambda.min)[-1]
  
  
  cat("Coefficients for Subsample", k, ":", coefficients_matrixa[, k], "\n")
}

zeros_counta <- rep(0, 31)
for (k in 1:31){
  zeros_counta[k] <- sum(coefficients_matrixa[k,] == 0)
  
}
zeros_counta
frequency_inclusiona=(200-zeros_counta)/200
frequency_inclusiona
valuesa=as.vector(frequency_inclusiona)
variable_names <- colnames(X)

png("FrequencyLASSOsub.png", width = 800, height = 600)
variables <- c('X12', 'X35.27', 'X0', 'X31.5', 'X0.1', 'X0.2', 'X1', 'X0.3', 'X0.4', 'X387',
                'X194', 'X129', 'X67', 'X348', 'X89.69072165', 'X8.762886598', 'X10.30927835',
               'X0.5', 'X50.1', 'X60','X40', 'X92', 'X80', 'X43', 'X27', 'X0.6', 'X130', 'X70',
               'X130.1', 'X70.1', 'X2.47')
barplot(valuesa, names.arg =variables, col = 'skyblue', ylim = c(0, 1), main = 'Frequency of inclusion',
        ylab = 'Frequency', cex.names = 0.7, las = 2)
abline(h = 0.3, col = "red", lty = 2)
dev.off()

#################################################################### BOOTSTRAP LASSO
library(glmnet)
file_X <- file.choose()
file_Y <- file.choose()
X <- read.csv(file_X)
x1=scale(Xnew)
Y <- unlist(read.csv(file_Y))
B <- 200
n <- nrow(X)
p <- ncol(X)
lambda_values <- numeric(B)
coefficients_matrix1 <- matrix(NA, nrow = p, ncol = B)
coefficients_matrix1
for (k in 1:B) {
  
  bootstrap_index <- sample(1:n, size = n, replace = TRUE)
  
  
  X_bootstrap <- as.matrix(X[bootstrap_index, ])
  Y_bootstrap <- as.numeric(Y[bootstrap_index])
  
  
  lasso_model <- cv.glmnet(X_bootstrap, Y_bootstrap, alpha = 1,standarize=TRUE)
  
  
  lambda_values[k] <- lasso_model$lambda.min
  
  
  coefficients_matrix1[, k] <- coef(lasso_model, s = lasso_model$lambda.min)[-1]
  
  
  cat("Coefficients for Bootstrap Sample", k, ":", coefficients_matrix1[,k], "\n")
}
zeros_count1 <- rep(0, 33)
for (k in 1:33){
  zeros_count1[k] <- sum(coefficients_matrix1[k,] == 0)
  
}
zeros_count1
frequency_inclusion1=(200-zeros_count1)/200
frequency_inclusion1

png("FrequencyLasso.png", width = 800, height = 600)
values <- as.vector(frequency_inclusion1)

variables <- c('X12', 'X35.27', 'X0', 'X31.5', 'X0.1', 'X0.2', 'X1', 'X0.3', 'X0.4', 'X387',
               'X50', 'X194', 'X129', 'X67', 'X348', 'X89.69072165', 'X8.762886598', 'X10.30927835',
               'X0.5', 'X50.1', 'X60','X40', 'X63', 'X92', 'X80', 'X43', 'X27', 'X0.6', 'X130', 'X70',
               'X130.1', 'X70.1', 'X2.47')
barplot(values, names.arg = variables, col = 'skyblue',ylim = c(0, 1), main = 'Frequency of inclusion',
        , ylab = 'Frequency', cex.names = 0.7,las=2)
abline(h = 0.3, col = "red",lty = 2)
dev.off()
length(values)
length(variables)
