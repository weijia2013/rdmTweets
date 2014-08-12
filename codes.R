load("rdmTweets.RData")
library(twitteR)
rdmTweets[11:15]

for (i in 11:15) {
        cat(paste("[[", i, "]] ", sep = ""))  
        writeLines(strwrap(rdmTweets[[i]]$getText(), width = 73))
}

df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
dim(df)

library(tm)
myCorpus <- Corpus(VectorSource(df$text))
myCorpusCopy <- myCorpus
class(myCorpus[[1]])
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeNumbers)
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
myCorpus <- tm_map(myCorpus, removeURL)
myStopwords <- c(stopwords("english"), "available", "via")
myStopwords <- setdiff(myStopwords, c("r", "big"))
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)

library(Snowball)
library(RWeka)
library(rJava)
library(RWekajars)

myCorpus <- tm_map(myCorpus, stemDocument)

for (i in 11:15) {
        cat(paste("[[", i, "]] ", sep = ""))
        writeLines(strwrap(myCorpus[[i]], width = 73))

}

myCorpus <- tm_map(myCorpus, stemCompletion, dictionary = myCorpusCopy)
inspect(myCorpus[11:15])
