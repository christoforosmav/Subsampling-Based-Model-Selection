#Due to confidentiality issues, coded names were given to the data. 
file_X <- file.choose() 
file_Y <- file.choose()
X <- read.csv(file_X)
Y <- read.csv(file_Y)
################################## Descriptive Statistics
descriptive_stats <- summary(X)
descriptive_stats
variables <- c('X12', 'X35.27', 'X0', 'X31.5', 'X0.1', 'X0.2', 'X1', 'X0.3', 'X0.4', 'X387',
               'X50', 'X194', 'X129', 'X67', 'X348', 'X88', 'X9', 'X11',
               'X0.5', 'X50.1', 'X60', 'X63', 'X92', 'X80', 'X43', 'X27', 'X0.6', 'X130', 'X70',
               'X130.1', 'X70.1', 'X2.47')
#################################################### Boxplots

colnames(X) <- c('X12', 'X35.27', 'X0', 'X31.5', 'X0.1', 'X0.2', 'X1', 'X0.3', 'X0.4', 'X387',
                 'X50', 'X194', 'X129', 'X67', 'X348', 'X88', 'X9', 'X11',
                 'X0.5', 'X50.1', 'X60','X40', 'X63', 'X92', 'X80', 'X43', 'X27', 'X0.6', 'X130', 'X70',
                 'X130.1', 'X70.1', 'X2.47')

exclude_columns <- c("X0" ,  "X0.1", "X0.2", "X1" ,  "X0.3")
selected_columns <- c('X12', 'X35.27', 'X31.5','X0.4', 'X387',
                      'X50', 'X194', 'X129', 'X67', 'X348', 'X88', 'X9', 'X11',
                      'X0.5', 'X50.1', 'X60', 'X63', 'X92', 'X80', 'X43', 'X27', 'X0.6', 'X130', 'X70',
                      'X130.1', 'X70.1', 'X2.47')

box1=X[c('X92', 'X35.27', 'X31.5','X0.4', 'X50','X50.1','X80','X40')]
box2=X[c('X194','X387', 'X348', 'X130', 'X130.1', 'X129')]
box3=X[c('X70','X60', 'X63', 'X70.1', 'X27', 'X43', 'X67','X88')]
box4=X[c('X0.6', 'X9', 'X11','X0.5', 'X2.47', 'X12')]


png("Boxplots1.png", width = 800, height = 600)

plot.new()

layout(matrix(1:4, nrow = 2))


boxplot(box1, col = "lightblue", border = "black", notch = TRUE, 
        pch = 19, cex.axis = 0.7, outlier.col = "red", boxfill = c("red", "lightblue"), outpch = "x",las=2,ylim = c(0, 105))


boxplot(box2, col = "lightblue", border = "black", notch = TRUE, 
        pch = 19, cex.axis = 0.7, outlier.col = "red", boxfill = c("red", "lightblue"), outpch = "x",las=2)


boxplot(box3, col = "lightblue", border = "black", notch = TRUE, 
        pch = 19, cex.axis = 0.7, outlier.col = "red", boxfill = c("red", "lightblue"), outpch = "x",las=2)


boxplot(box4, col = "lightblue", border = "black", notch = TRUE, 
        pch = 19, cex.axis = 0.7, outlier.col = "red", boxfill = c("red", "lightblue"), outpch = "x",las=2,ylim = c(0, 100))

dev.off()


########################################## Correlation Matrix
install.packages("corrplot")
library(corrplot)

pairs(X, pch = 16, col = "blue")
selected_columns <- selected_data

Xnew <- as.matrix(X[, !colnames(X) %in% c("X50","X63")])
x1=scale(Xnew)
png("corrmatrix1.png", width = 800, height = 600)

cor_matrix <- cor(X)
cor_matrix1<- cor(x1)
cor_matrix1
#dev.new()
corrplot(cor_matrix1, method = "circle", type = "lower", tl.col = "black")
dev.off()

#Create the correlation plot
corrplot(cor_matrix1, method = "color")

