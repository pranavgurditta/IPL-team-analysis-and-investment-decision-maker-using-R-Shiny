
library(shiny)
library(shinydashboard)
shinyUI(dashboardPage(skin="purple",
  dashboardHeader(title="Menu driven application in R ",titleWidth = 350),
  dashboardSidebar(
    width=350,
  menuItem("Dashboard",tabName="Dashboard"),
  menuItem("Text based sentiment analysis",tabName="t1"),
  menuItem("Comparison of winning chances of 2 IPL teams",tabName="t2"),
  menuItem("IPL team tweet analysis",tabName="t3")
  ),  
  dashboardBody(
  
    tabItems(
      tabItem(tabName="t2",
              sidebarPanel(
                selectInput("team","IPL TEAM 1",c("Royal Challengers Bangalore"="@RCBTweets","Chennai Super Kings"="@ChennaiIPL","Kolkata Knight Riders"="@KKRiders","Rajasthan Royals"="@rajasthanroyals","Mumbai Indians"="@mipaltan","Sunrisers Hyderabad"="@SunRisers","Delhi daredevils"="@DelhiDaredevils","KingsXIPunjab"="@lionsdenkxip")),
                
                selectInput("team1","IPL TEAM 2",c("Royal Challengers Bangalore"="@RCBTweets","Chennai Super Kings"="@ChennaiIPL","Kolkata Knight Riders"="@KKRiders","Rajasthan Royals"="@rajasthanroyals","Mumbai Indians"="@mipaltan","Sunrisers Hyderabad"="@SunRisers","Delhi daredevils"="@DelhiDaredevils","KingsXIPunjab"="@lionsdenkxip")),
                actionButton("search", "Compare")
              ),
              textOutput(outputId = "text1"),
              (plotOutput(outputId = "distPlot3")
              
              
              )
      )
      ,
      tabItem(tabName="t3",
              sidebarPanel(
                selectInput("team3","Find positivity or negativity of tweets of the following IPL team",c("Royal Challengers Bangalore"="@RCBTweets","Chennai Super Kings"="@ChennaiIPL","Kolkata Knight Riders"="@KKRiders","Rajasthan Royals"="@rajasthanroyals","Mumbai Indians"="@mipaltan","Sunrisers Hyderabad"="@SunRisers","Delhi daredevils"="@DelhiDaredevils","KingsXIPunjab"="@lionsdenkxip")),
                
                  actionButton("search3", "Compare")
              ),
              
              (plotOutput(outputId = "distPlot4")
               
               
              )
      ),
      
      tabItem(tabName="t1",
              sidebarPanel(
                textInput("word", "Word", "Twitter"),
                actionButton("search2", "Search")
              ),
              
              (plotOutput(outputId = "distPlot5")
               
               
              )
      )
      
       )
  )
  )
)
