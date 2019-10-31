dates <- seq(as.Date("2016/01/01"),
             by = "month",
             length.out = 40)
row_label <- c("A: format 1",
               "B: format 2",
               "C: format 3",
               "D: format 4")
library(data.table)
init_table <- CJ(dates, row_label)
count_curr <- sample(33000:55000,
                     size = nrow(init_table),
                     replace = TRUE)
sample_data <- data.frame(date = init_table$dates,
                          row_label = init_table$row_label,
                          count = count_curr)
str(sample_data)
head(sample_data)
write.csv(x = sample_data,
          file = "sample_data.csv",
          row.names = FALSE,
          col.names = TRUE,
          quote = FALSE)