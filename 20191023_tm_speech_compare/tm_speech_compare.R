library(tm)
library(wordcloud)

setwd("/home/jtapia/github/ssibd/tm_speech_compare_20191023")
getwd()
list.files()

readFiles <- function(filenm) {
  tmp_path <- paste0(getwd(), "/", filenm)
  tmp_tbl <- readChar(con = tmp_path, 
                      nchars = file.info(tmp_path)$size)
  return(tmp_tbl)
}

cleanText <- function(x)
{
  x <- chartr('áéíóú', 'aeiou', x)
  x <- gsub("\r?\n|\r", " ", x)
  x <- gsub("[ |\t]{2,}", " ", x)
  x <- gsub("^ ", "", x)
  x <- gsub(" $", "", x)
  x <- gsub("<", "", x)
  x <- gsub(">", "", x)
  x <- gsub("[[:punct:]]", " ", x)
  x <- gsub("[[:digit:]]", " ", x)
  x <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", " ", x, perl=TRUE)
}
plotWordclouds <- function(inputm)
{
  speeches <- colnames(inputm)
  wcs <- paste(paste("wordcloud",
                     speeches,
                     sep = "-"),
               ".png",
               sep = "")
  bps <- paste(paste("barplot",
                     speeches,
                     sep = "-"),
               ".png",
               sep = "")
  ncolMat <- ncol(inputm)
  for(i in 1:ncolMat)
  {
    tmp_mt <- matrix(data = inputm[, i],
                     nrow = nrow(inputm),
                     ncol = 1,
                     byrow = TRUE)
    colnames(tmp_mt) <- colnames(inputm)[i]
    rownames(tmp_mt) <- rownames(inputm)
    tmp_vc <- sort(rowSums(tmp_mt),
                   decreasing = TRUE)
    tmp_df <- data.frame(word = names(tmp_vc),
                         freq = tmp_vc)
    png(wcs[[i]])
    wordcloud(words = tmp_df$word,
              freq = tmp_df$freq,
              random.order = FALSE,
              min.freq = 3,
              max.words = 100,
              colors = brewer.pal(8, "Dark2"),
              scale = c(4, .2),
              rot.per = 0.5)
    dev.off()
    png(bps[[i]])
    barplot(height = tmp_df[1:10, ]$freq,
            las = 2,
            names.arg = tmp_df[1:10, ]$word,
            col = "lightblue",
            main = "Top 10 palabras más usadas",
            ylab = "cnt")
    dev.off()
  }
}

oct19 <- readFiles("speech_19_10.txt")
oct20 <- readFiles("speech_20_10.txt")
oct21 <- readFiles("speech_21_10.txt")
oct22 <- readFiles("speech_22_10.txt")

oct19 <- cleanText(oct19)
oct20 <- cleanText(oct20)
oct21 <- cleanText(oct21)
oct22 <- cleanText(oct22)

speeches_corpus <- VCorpus(VectorSource(c(oct19, 
                                          oct20,
                                          oct21,
                                          oct22)))
speeches_corpus <- tm_map(speeches_corpus,
                          stripWhitespace)
speeches_corpus <- tm_map(speeches_corpus,
                          content_transformer(tolower))
speeches_corpus <- tm_map(speeches_corpus,
                          removeWords,
                          stopwords("spanish"))

speeches_tdm <- TermDocumentMatrix(speeches_corpus)
speeches_mat <- as.matrix(speeches_tdm)
colnames(speeches_mat) <- c("oct19",
                            "oct20",
                            "oct21",
                            "oct22")

plotWordclouds(speeches_mat)

png("comparison-cloud.png")
comparison.cloud(speeches_mat,
                 random.order = FALSE,
                 title.size = 0.8,
                 max.words = 300)
dev.off()

png("commonality-cloud.png")
commonality.cloud(speeches_mat,
                  random.order = FALSE,
                  max.words = 300)
dev.off()