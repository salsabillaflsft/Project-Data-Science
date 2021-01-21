library(tm)
library(NLP)
library(Rstem)
library(sentiment)
library(SnowballC)
library(SentimentAnalysis)
library(plyr)
library(textclean)
library(stringr)
library(caret)
library(dplyr)
library(tau)

#Import Data

dataBiden <- read.csv("~/Project-Data-Science/Bidenall.csv")
dataTrump <- read.csv("~/Project-Data-Science/Trumpall.csv")

data1 <- dataBiden$text
data2 <- dataTrump$text

# Data Cleaning

#clean rt entities
data1 = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", data1)
data2 = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", data2)
#clean @
data1 = gsub("@\\w+", "", data1)
data2 = gsub("@\\w+", "", data2)
#clean punctuation
data1 = gsub("[[:punct:]]", "", data1)
data2 = gsub("[[:punct:]]", "", data2)
#clean numbers
data1 = gsub("[[:digit:]]", "", data1)
data2 = gsub("[[:digit:]]", "", data2)
#clean html links
data1 = gsub("http\\w+", "", data1)
data2 = gsub("http\\w+", "", data2)
#clean spaces
data1 = gsub("[ \t]{2,}", "", data1)
data1 = gsub("^\\s+|\\s+$", "", data1)
data1 = gsub("note", "", data1)
data2 = gsub("[ \t]{2,}", "", data2)
data2 = gsub("^\\s+|\\s+$", "", data2)
data2 = gsub("note", "", data2)
#uppercase to lowercase
try.error = function(x)
{
  y = NA
  try_error = tryCatch(tolower(x), error=function(e) e)
  if (!inherits(try_error, "error"))
  y = tolower(x)
  return(y)
}
data1 = sapply(data1, try.error)
data2 = sapply(data2, try.error)
#remove NAs & null
data1 = data1[!is.na(data1)]
data1 <- data1[!data1 == "" ] 
data2 = data2[!is.na(data2)]
data2 <- data2[!data2 == "" ] 
names(data1) = NULL
names(data2) = NULL

write.csv(data1,"~\\Project-Data-Science\\dataCleanedBiden.csv")
write.csv(data2,"~\\Project-Data-Science\\dataCleanedTrump.csv")


# Sentiment Analysis using Emotion Classification
  # Input: text (tweets); Output: emotion class
  
  # emotion classification
  emotionClass <- classify_emotion(data1, algorithm="bayes", prior=1.0)
  
  # extract emotion with the best possible fit
  emotion <- emotionClass[,7]
  
  # setting emotions having NA to "unknown"
  emotion[is.na(emotion)] <- "unknown"
  

# Sentiment Analysis using Polarity Classification
  # Input: text (tweets); Output: polarity class
  
  # polarity classification
  polarityClass <- classify_polarity(data1, algorithm="bayes")
  
  # extract polarity with the best possible fit
  polarity <- polarityClass[,4]
  
  # setting polarity having NA to "unknown"
  polarity[is.na(polarity)] <- "unknown"

