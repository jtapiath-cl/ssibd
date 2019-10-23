library(tm)
library(wordcloud)

setwd("/home/jtapia/github/ssibd/tm_speech_20191023")

getwd()
list.files()
speech_txt <- readChar(con = paste0(getwd(), "/input_speech.txt"),
                       nchars = file.info(paste0(getwd(), "/input_speech.txt"))$size)
cleanText <- function(x)
{
  x <- chartr('áéíóú', 'aeiou', x)
  x <- gsub("\r?\n|\r|\t", " ", x)
  x <- gsub("[ |\t]{2,}", " ", x)
  x <- gsub("^ ", "", x)
  x <- gsub(" $", "", x)
  x <- gsub("<", "", x)
  x <- gsub(">", "", x)
  x <- gsub("[[:punct:]]", " ", x)
  x <- gsub("[[:digit:]]", " ", x)
  x <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", " ", x, perl=TRUE)
}
speech_clean <- cleanText(speech_txt)
library(tm)
speech_corpus <- VCorpus(VectorSource(speech_clean))
speech_corpus <- tm_map(speech_corpus,
                        stripWhitespace)
speech_corpus <- tm_map(speech_corpus,
                        content_transformer(tolower))
speech_corpus <- tm_map(speech_corpus,
                        removeWords, stopwords("spanish"))
speech_tdm <- TermDocumentMatrix(speech_corpus)
speech_matrix <- as.matrix(speech_tdm)
speech_vector <- sort(rowSums(speech_matrix),
                      decreasing = TRUE)
speech_df <- data.frame(word = names(speech_vector),
                        freq = speech_vector)
head(speech_df)
wordcloud(words = speech_df$word,
          freq = speech_df$freq,
          min.freq = 1,
          max.words = 100,
          random.order = FALSE,
          colors = brewer.pal(8, "Dark2"),
          scale = c(2, .2),
          rot.per = 0.5)
barplot(height = speech_df[1:10,]$freq,
        las = 2,
        names.arg = speech_df[1:10,]$word,
        col = "lightblue",
        main = "Palabras más comunes, top 10",
        ylab = "cnt")