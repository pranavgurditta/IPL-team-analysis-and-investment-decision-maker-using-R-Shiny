library(plotrix)
library(shiny)
library(twitteR)
library(stringr)
library(plyr)

##SENTIMENT FUNCTION
score.sentiment<-function(sentences, pos.words, neg.words, .progress='none')
{
  scores <- laply(sentences, function(sentence, pos.words, neg.words){
    sentence <- gsub('[[:punct:]]', "", sentence)
    sentence <- gsub('[[:cntrl:]]', "", sentence)
    sentence <- gsub('\\d+', "", sentence)
    
    sentence <- tolower(sentence)
    word.list <- str_split(sentence, '\\s+')
    words <- unlist(word.list)
    pos.matches <- match(words, pos.words)
    neg.matches <- match(words, neg.words)
    pos.matches <- !is.na(pos.matches)
    neg.matches <- !is.na(neg.matches)
    score <- sum(pos.matches) - sum(neg.matches)
    return(score)
  }, pos.words, neg.words, .progress=.progress)
  scores.df <- data.frame(score=scores, text=sentences)
  return(scores.df)
}

consumer_key <- "CzUJcMqojfMOEczNBmN47QI7x"
consumer_secret <- "IbN82fBTOrcmxgS42yepcvez3as7G4fLZsHVCd4Mutv8bs5z8j"
access_token <- "4845037632-M9vy2bZTQuI1RInEECFu4572WZTAGK3z5D95h7J"
access_secret <- "l9Vhang7KluC1ddPFgKDNrwBgFeSBwWWINpejcaDgySEa"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


  server <- function(input,output,session) {
    observeEvent( input$search,{
      x <- input$team
      y<- input$team1
      tweet1 <- userTimeline(x,n=3000)
      tweet2 <- userTimeline(y,n=3000)
      tweet1_df <- twListToDF(tweet1)
      tweet2_df <- twListToDF(tweet2)
      
      
      pos.words = scan('C:/Users/yati/Desktop/Sentiment Analysis/positive-words.txt',what='character',comment.char=';')
      neg.words = scan('C:/Users/yati/Desktop/Sentiment Analysis/negative-words.txt',what='character',comment.char=';')
      bscore <- score.sentiment(tweet1_df$text,pos.words,neg.words,.progress='text')
      rscore <- score.sentiment(tweet2_df$text,pos.words,neg.words,.progress='text')
      
       pie.pe<-c(sum(bscore$score),sum(rscore$score))
       lbls <- c(x,y)
       pct <- round((pie.pe/sum(pie.pe))*100)
       lbls <- paste(lbls, pct,"%") # add percents to labels 
       output$distPlot3<-renderPlot(pie3D(pie.pe,labels=lbls,explode=0.1,
                                          main=paste("Comparison of winning chances of 2 teams:", x,"vs",y)))
       
      })
    
    observeEvent(input$search3,{
      x1 <- input$team3
      tweet3 <- userTimeline(x1,n=300)
      tweet3_df <- twListToDF(tweet3)
      
      pos.words1 = scan('C:/Users/yati/Desktop/Sentiment Analysis/positive-words.txt',what='character',comment.char=';')
      neg.words1 = scan('C:/Users/yati/Desktop/Sentiment Analysis/negative-words.txt',what='character',comment.char=';')
      teamscore <- score.sentiment(tweet1_df$text,pos.words1,neg.words1,.progress='text')
        c1=0
      c2=0
      c3=0
      c4=0
      c5=0
      for (row in 1:nrow(teamscore)) 
        {
      if(teamscore$score[row]<=(-2))
        {
        teamscore$score[row]=-2
        c1=c1+1
      }
        if(teamscore$score[row]==(-1))
          {
          c2=c2+1
        }
        if(teamscore$score[row]==0){
          teamscore$score[row]=0
          c3=c3+1
        }
        if(teamscore$score[row]==1){
        
          c4=c4+1
        }
        if(teamscore$score[row]>=2){
          teamscore$score[row]=2
          c5=c5+1
        }
      
        teamscore$score[row]=teamscore$score[row]*10;
      }
      pie.pe<-c(c1,c2,c3,c4,c5)
      names(pie.pe)<-c("Very negative","Negative","Neutral","Positive","Very Positive")
      pct <- round((pie.pe/sum(pie.pe))*100)
      names(pie.pe) <- paste(names(pie.pe), pct,"%") # add percents to labels 
      output$distPlot4<-renderPlot(pie(pie.pe,
                                         main=paste("Pie Chart Comparison of Positive/Negative Tweets of team",x1)))
      })
    observeEvent( input$search2,{
      x11 <- input$word
      
      tweet32 <- searchTwitter(x11,n=300)
      tweet32 <- twListToDF(tweet32)
      
      #save all the spaces, then get rid of the weird characters that break the API, then convert back the URL-encoded spaces.
      tweet32$text <- str_replace_all(tweet32$text, "%20", " ");
      tweet32$text <- str_replace_all(tweet32$text, "%\\d\\d", "");
     
        pos.words2 = scan('C:/Users/yati/Desktop/Sentiment Analysis/positive-words.txt',what='character',comment.char=';')
      neg.words2 = scan('C:/Users/yati/Desktop/Sentiment Analysis/negative-words.txt',what='character',comment.char=';')
      teamscore2 <- score.sentiment(tweet32$text,pos.words2,neg.words2,.progress='text')
      output$sum4<-renderPrint(paste("The use of this word in negative or positive is ",x11," are :",sum(teamscore2$score)))
      
      output$distPlot5<-renderPlot({hist(teamscore2$score,main="Text based sentiment analysis",xlab="Positivity/Negativity score",
                                         ylab="Frequency of tweets",col=c("red","cyan","blue","green2","brown","pink"))  })
    
    
    })
    
  }
  

  
