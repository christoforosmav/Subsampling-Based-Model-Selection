######## Bootstrap for BOTH ADAPTIVE LASSO AND LASSO
################## 2ND APPLICATION FOR LASSO
library(glmnet)
file_X <- file.choose()
file_Y <- file.choose()
#Exclude predictors after threshold criteria (frequency of inclusion)
X2nd<-x1[, !colnames(x1) %in% c("X50","X63",'X35.27','X1','X0.3','X129','X348','X89.69072165', 'X8.762886598','X50.1','X40','X92')]
X2nd
Y <- unlist(read.csv(file_Y))
y1<-scale(Y)
B <- 200
n <- nrow(X2nd)   
p <- ncol(X2nd)
coefficients_matrix2nd <- matrix(NA, nrow = p, ncol = B)

for (k in 1:B) {
  
  bootstrap_index <- sample(1:n, size = n, replace = TRUE)
  
  X_bootstrap <- as.matrix(X2nd[bootstrap_index, ])
  Y_bootstrap <- as.numeric(y1[bootstrap_index])
  
  
  lm_model <- lm(Y_bootstrap ~ ., data = data.frame(Y_bootstrap, X_bootstrap))
  
  coefficients_matrix2nd[, k] <- coef(lm_model)[-1]
 
  
  cat("Coefficients for Bootstrap Sample", k, ":", coefficients_matrix2nd[, k], "\n")
}


avg_coefficients <- colMeans(coefficients_matrix2nd)
print(avg_coefficients)

confidence_intervals <- t(apply(coefficients_matrix2nd, 1, function(x) quantile(x, c(0.05, 0.95))))
print(confidence_intervals)
length(confidence_intervals[,1])
library(ggplot2)


x_labels <- colnames(X2nd)
length(x_labels)

plot_data <- data.frame(
  x = x_labels,
  y = rowMeans(confidence_intervals),  
  ymin = confidence_intervals[,1],  
  ymax = confidence_intervals[,2]   
)

p <- ggplot(plot_data, aes(x = x, y = y)) +
  geom_point(color = "blue", size = 3) +  
  geom_errorbar(aes(ymin = ymin, ymax = ymax), color = "red", width = 0.2) + 
  labs(
    x = "Predictor Variables",
    y = "Coefficient Estimate",
    title = "Coefficients with 90% Confidence Intervals"
  ) +
  theme_light() +  
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 10, family = "sans"),  
    axis.title.x = element_text(size = 12, family = "sans"), 
    axis.title.y = element_text(size = 12, family = "sans")
    
  ) + 
  geom_hline(yintercept = 0, col = "black", lty = 1)


ggsave("CILASSO.png", plot = p, width = 10, height = 6, units = "in", dpi = 300)
dev.off()


################## 2ND APPLICATION FOR ADAPTIVE LASSO

X22nd <- x1[, !colnames(x1) %in% c("X50","X63",'X35.27','X1','X0.3','X129','X348','X89.69072165','X8.762886598','X50.1','X40','X92')]
Y <- unlist(read.csv(file_Y))
y1<- scale(Y)
B <- 200
n <- nrow(X22nd)
p <- ncol(X22nd)
lambda_values22 <- numeric(B)
coefficients_matrix22 <- matrix(NA, nrow = p, ncol = B)

for (k in 1:B) {
  
  bootstrap_index <- sample(1:n, size = n, replace = TRUE)
  
  X_bootstrap <- as.matrix(X22nd[bootstrap_index, ])
  Y_bootstrap <- as.numeric(y1[bootstrap_index])
  
  
  lm_model <- lm(Y_bootstrap ~ ., data = data.frame(Y_bootstrap, X_bootstrap))
  
  coefficients_matrix22[, k] <- coef(lm_model)[-1]
  
  
  cat("Coefficients for Bootstrap Sample", k, ":", coefficients_matrix22[, k], "\n")
}


avg_coefficients1 <- colMeans(coefficients_matrix22)
print(avg_coefficients1)


confidence_intervals1 <- t(apply(coefficients_matrix22, 1, function(x) quantile(x, c(0.05, 0.95))))
print(confidence_intervals1)

x_labels <- colnames(X22nd)


plot_data <- data.frame(
  x = x_labels,
  y = rowMeans(confidence_intervals1),  
  ymin = confidence_intervals1[,1],  
  ymax = confidence_intervals1[,2]  
)

p <- ggplot(plot_data, aes(x = x, y = y)) +
  geom_point(color = "blue", size = 3) +  
  geom_errorbar(aes(ymin = ymin, ymax = ymax), color = "red", width = 0.2) +  
  labs(
    x = "Predictor Variables",
    y = "Coefficient Estimate",
    title = "Coefficients with 90% Confidence Intervals"
  ) +
  theme_light() +  
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 10, family = "sans"),  
    axis.title.x = element_text(size = 12, family = "sans"),  
    axis.title.y = element_text(size = 12, family = "sans")
  ) +
  geom_hline(yintercept = 0, col = "black", lty = 1)


ggsave("CIALASSO.png", plot = p, width = 10, height = 6, units = "in", dpi = 300)
dev.off()



