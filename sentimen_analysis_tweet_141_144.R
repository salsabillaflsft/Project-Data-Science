library(tm)
library(SentimentAnalysis)
library(sentiment) #package for for Sentiment Analysis
library(ggplot2) #package for data visualisations
library(plyr)
library(ggpubr)


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
  emotionClass1 = classify_emotion(data1, algorithm="bayes", prior=1.0)
  emotionClass2 = classify_emotion(data2, algorithm="bayes", prior=1.0)

  # extract emotion with the best possible fit
  emotion1 = emotionClass1[,7]
  emotion2 = emotionClass2[,7]
  
  # setting emotions having NA to "unknown"
  emotion1[is.na(emotion1)] = "unknown"
  emotion2[is.na(emotion2)] = "unknown"


# Sentiment Analysis using Polarity Classification
# Input: text (tweets); Output: polarity class

  # polarity classification
  polarityClass1 = classify_polarity(data1, algorithm="bayes")
  polarityClass2 = classify_polarity(data2, algorithm="bayes")
  
  # extract polarity with the best possible fit
  polarity1 = polarityClass1[,4]
  polarity2 = polarityClass2[,4]
  
  # setting polarity having NA to "unknown"
  polarity1[is.na(polarity1)] = "unknown"
  polarity2[is.na(polarity2)] = "unknown"

# Store results in dataframe
  results_data1 <- data.frame(text=data1, emotion=emotion1, polarity=polarity1)
  results_data2 <- data.frame(text=data2, emotion=emotion2, polarity=polarity2)
  
  write.csv(results_data1, "~\\Project-Data-Science\\dataSentimenBiden.csv")
  write.csv(results_data2, "~\\Project-Data-Science\\dataSentimenTrump.csv")
  
  # sort data frame
  results_data1_sort = within(results_data1,
                         emotion <- factor(emotion1, levels=names(sort(table(emotion1), decreasing=TRUE))))
  results_data2_sort = within(results_data2,
                         emotion <- factor(emotion2, levels=names(sort(table(emotion2), decreasing=TRUE))))

   
# Plot distribution of tweet sentiments
# Emotion Plot
  #Biden
  plot1 <- ggplot(results_data1_sort, aes(x=emotion)) +
            geom_bar(aes(y=..count.., fill=emotion)) +
            scale_fill_manual(values = c("#bababa", "#96f78f", "#8fdaf7","#f7988f","#fa5c5c","#f7d48f","#dea050")) +
            labs(x="emotion categories", y="number of tweets",title = "Sentiment Analysis towards Joe Biden Tweets") +
            theme(plot.title = element_text(size=12))
                                                                                                                                 
  #Trump
  plot2 <- ggplot(results_data2_sort, aes(x=emotion)) +
              geom_bar(aes(y=..count.., fill=emotion)) +
              scale_fill_manual(values = c("#bababa", "#96f78f", "#8fdaf7","#fa5c5c","#f7988f","#dea050","#f7d48f")) +
              labs(x="emotion categories", y="number of tweets", title = "Sentiment Analysis towards Donald Trump Tweets")+
              theme(plot.title = element_text(size=12))
  
# Polarity Plot
  #Biden
  plot3 <- ggplot(results_data1_sort, aes(x=polarity))+
            geom_bar(aes(y=..count.., fill=polarity)) +
            scale_fill_brewer(palette="Set1") +
            labs(x="polarity categories", y="number of tweets",title="Sentiment Analysis towards Joe Biden Tweets")+
            theme(plot.title = element_text(size=12))
  
  #Trump
  plot4 <- ggplot(results_data2_sort, aes(x=polarity))+
            geom_bar(aes(y=..count.., fill=polarity)) +
            scale_fill_brewer(palette="Set1") +
            labs(x="polarity categories", y="number of tweets",title = "Sentiment Analysis towards Donald Trump Tweets")+
            theme(plot.title = element_text(size=12))
  
# Data
  table(results_data1_sort$emotion)
  table(results_data2_sort$emotion)
  table(results_data1_sort$polarity)
  table(results_data2_sort$polarity)
  
