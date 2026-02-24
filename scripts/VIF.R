
f <- file.choose()
data <- read.csv(f)

vif_func <- function(in_dat, thresh = 20, trace = T, ...) {
  library(fmsb)
  

  if (is.null(in_dat) || nrow(in_dat) == 0) {
    return(NULL)
  }
  
  vif_vals <- NULL
  var_names <- names(in_dat)
  
  for (val in var_names) {
    regressors <- var_names[-which(var_names == val)]
    form <- paste(regressors, collapse = '+')
    form_in <- formula(paste(val, '~', form))
    vif_add <- VIF(lm(form_in, data = in_dat, ...))
    vif_vals <- rbind(vif_vals, c(val, vif_add))
  }
  
  if (any(is.na(as.numeric(vif_vals[, 2]))) || all(is.na(as.numeric(vif_vals[, 2])))) {
    return(NULL)
  }
  
  max_row<-which(vif_vals[,2] == max(as.numeric(vif_vals[,2]), na.rm = TRUE))[1]
  vif_max<-as.numeric(vif_vals[max_row,2])
  
  if (trace) {
    prmatrix(vif_vals, collab = c('Variable', 'VIF'), rowlab = rep('', nrow(vif_vals)), quote = FALSE)
    cat('\n')
    cat('removed: ',vif_vals[max_row,1],vif_max,'\n\n')
    flush.console()
  }
  
  if(vif_max<thresh) break
}


result <- vif_func(data)

