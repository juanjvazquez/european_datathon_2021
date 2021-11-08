library(pacman)
pacman::p_load(pacman,dplyr,GGally, ggplot2,ggthemes,ggvis,httr,lubridate,plotly,rio,rmarkdown,shiny,stringr,tidyr,markdown,rprojroot,gridExtra)
p_load(psych)
library(readxl)
analytics <- read.delim("C:/Users/Gokhan Mutlu/Desktop/datathon/analytics.txt")
View(analytics)
attach(analytics)

#This turns of scientific notation that appears on graphs - if you set this to zero it will go back to sci notation
options(scipen=999)

#look at variables
names(analytics)

#Create new variables and attach to new dataframe caled analytics2- this is expected to give better graphs
pageviews_g_m <-data.frame(pageviews_g_m=(analytics$pageviews_general/1000000))
pageviews_u_m <-data.frame(pageviews_u_m=(analytics$pageviews_user/1000000))
users_m<-data.frame(users_m=(analytics$users/1000000))
New_users_m<-data.frame(New_users_m=(analytics$new_users/1000000))
analytics2<-cbind(analytics,users_m,pageviews_g_m,New_users_m,pageviews_u_m)

#Visualize pageviews
#1.histograms
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
hist(analytics2$pageviews_general, xlab=(paste("No of Pageviews From User Data")), main="Histogram of Pageviews From User Data")
hist(analytics2$pageviews_user, xlab=(paste("No of Pageviews From General Data")), main="Histogram of Pageviews From General Data")

#2.scatterplots in general units or in millions
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(analytics2$pageviews_general,analytics2$pageviews_user, xlab=paste("No of Pageviews From General Data"), ylab=paste("No of Pageviews From Analytics_daily_users Data"), main="Pageviews")
plot(analytics2$pageviews_g_m,analytics2$pageviews_u_m, xlab=paste("No of Pageviews From Analytics_daily_pageviews Data","
(millions)"), ylab=paste("No of Pageviews From User Data", "
(millions)"), main="Pageviews")


#3.overlay plot of time series graph data of pageview data from general google analytics vs pageview data from users sheet in millions
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(date_general_google,analytics2$pageviews_u_m, type="p", main ="Pageviews Over Time", ylab=(paste("No of Pageviews","
(millions)")), xlab=" ", col=c("#0000FF"), cex=0.5, ylim= c(0,14))
add=TRUE
points(date_general_google,analytics2$pageviews_g_m, type="p", col=c("#FF00FF"), cex=0.5)
legend(x="topright",
       cex=0.6,
       legend=(c("General Pageviews","User Pageviews")),
       pch = 1,
       col=c("#0000FF","#FF00FF"))

#4. Overlay plot of time series graph of pageview data from general google analytics vs pageview data from users sheet
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(date_general_google,pageviews_user, type="p", main ="Pageviews Over Time", ylab=(paste("Number of","
pageviews")), xlab=" ", col=c("#0000FF"), cex=0.5, ylim= c(0, 14000000))
add=TRUE
points(date_general_google,pageviews_general, type="p", col=c("#FF00FF"), cex=0.5)
legend(x="topright",
       cex=0.6,
       legend=(c("General Pageviews","User Pageviews")),
       pch = 1,
       col=c("#0000FF","#FF00FF"))

#Regression of Pageview General Data against Pageview User Data available Portion
#1.General Regression is created here
regPageviews <- lm (pageviews_user ~pageviews_general)
summary(regPageviews)
names(regPageviews)
#2. histogram of Residuals
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
hist(regPageviews$residuals, main="Histogram of Residuals", xlab="Residuals from Regression of Pageviews")
shapiro.test(regPageviews$residuals)

#Visualize User data
#1. Histograms
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
hist(analytics2$users_m, xlab=(paste("No of Users (millions)")), main="Histogram of Number of Total Users")
hist(analytics2$New_users_m, xlab=(paste("No of New Users (millions)")), main="Histogram of Number of New Users")

#2. Overlay plot of User data
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(analytics2$date_general_google,analytics2$users_m, type="p", main ="All Users and New Users Over Time", ylab=(paste("No of users (millions)")), xlab="Year", col=c("#FF0099"), cex=0.5, ylim= c(0,14))
add=TRUE
points(analytics2$date_general_google,analytics2$New_users_m, type="p", col=c("#009999"), cex=0.5)
legend(x="topright",
       cex=0.6,
       legend=(c("Total Users","New Users")),
       pch = 1,
       col=c("#FF0099","#009999"))

#3.Overlay plot of User data and Pageview Data
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(analytics2$date_general_google,analytics2$users_m, type="p", main ="Users and Pageviews Over Time", ylab=(paste("Number (millions)")), xlab="Year", col=c("#0000FF"), cex=0.5, ylim=c(0,14))
add=TRUE
points(analytics2$date_general_google,analytics2$New_users_m, type="p", col=c("#009999"), cex=0.5)
add=TRUE
points(analytics2$date_general_google,analytics2$pageviews_g_m, type="p",col=c("#FF00FF"), cex=0.5)
legend(x="topright",
       cex=0.6,
       legend=(c("Pageviews","Total Users","New Users")),
       pch = 1,
       col=c("#0000FF","#FF00FF","#009999"))

#Visualize session and page data per user
#1. add new session variable in millions
sessions_m<-data.frame(sessions_m=(analytics$sessions/1000000))
analytics2<-cbind(analytics,users_m,pageviews_g_m,New_users_m,pageviews_u_m,sessions_m)

#2.Add expected variables based on expected logical relationships within data
#Expected_Pageviews1 should equal Users X Sessions per User X Pages per Session
Expected_Pageviews1<-data.frame(Expected_Pageviews1=(analytics2$users*analytics2$sessions_per_user*analytics2$pages_per_session))

#Expected_sessions should equal Users X Sessions per User
Expected_sessions<-data.frame(Expected_sessions=(analytics2$users *analytics2$sessions_per_user))

#Expected_Pageviews2 should equal Sessions X Pages per session
Expected_Pageviews2<-data.frame(Expected_Pageviews2=(analytics2$sessions* analytics2$pages_per_session))
analytics2<-cbind(analytics2,Expected_Pageviews1,Expected_Pageviews2,Expected_sessions)

#3. Histograms
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
hist(analytics2$sessions_m, xlab=(paste("No of Sessions (millions)")), main="Histogram of Number of Sessions")
hist(analytics2$sessions_per_user, xlab=(paste("No of Sessions per User")), main="Histogram of Sessions per User")
hist(analytics2$pages_per_session, xlab=(paste("No of Pages per Session")), main="Histogram of Number of Pages per Session")
hist(analytics2$bounce_rate, xlab=(paste("Percent of Sessions with One Pageview")), main="Histogram of Percent of Sessions with One Pageview")
hist(analytics2$session_duration, xlab=(paste("Session Duration (min:sec)")), main="Histogram of Session Duration", breaks=10)
hist(analytics2$Expected_Pageviews1, xlab=(paste("Number of Expected_Pageviews1=Users*Sessions_per_user*pages_per_session")), main="Histogram of Expected_Pageviews1")
hist(analytics2$Expected_Pageviews1, xlab=(paste("Number of Expected_Pageviews2=Sessions*pages_per_session")), main="Histogram of Expected_Pageviews2")
hist(analytics2$Expected_sessions, xlab=(paste(" Number of Expected_Sessions=Users*Sessions_per_user")), main="Histogram of Expected_Sessions")

#4. Overlay plots of Sessions and Expected Sessions
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(analytics2$date_general_google,analytics2$sessions, type="p", main ="Sessions Vs Expected Sessions Over Time", ylab=(paste("No of Sessions")), xlab=" ", col=c("#FF3300"), cex=0.5, ylim= c(0,14000000))
add=TRUE
points(analytics2$date_general_google,analytics2$Expected_sessions, type="p", col=c("#99FF00"), cex=0.5)
add=TRUE
legend(x="topright",
       cex=0.6,
       legend=(c("Sessions","Expected Sessions")),
       pch = 1,
       col=c("#FF3300","#99FF00"))

#5. Overlay plots of Pageviews and Expected Pageviews
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(analytics2$date_general_google,analytics2$pageviews_general, type="p", main ="Pageviews Vs Expected_Pageviews Over Time", ylab=(paste("No of Pageviews")), xlab=" ", col=c("#0000FF"), cex=0.5, ylim= c(0,14000000))
add=TRUE
points(analytics2$date_general_google,analytics2$Expected_Pageviews1, type="p", col=c("#FF3300"), cex=0.5)
add=TRUE
points(analytics2$date_general_google,analytics2$Expected_Pageviews2, type="p", col=c("#99FF00"), cex=0.5)
add=TRUE
legend(x="topright",
       cex=0.6,
       legend=(c("Pageviews","Expected_Pageviews1","Expected_Pageviews2")),
       pch = 1,
       col=c("#0000FF","#FF3300","#99FF00"))

#Regression of Pageview General Data against Expected Pageview Data
#1.General Regression is created here for regression of pageviews vs Expected_Pageviews1
regPageviews2 <- lm (analytics2$pageviews_general ~ analytics2$Expected_Pageviews1)
summary(regPageviews2)
names(regPageviews2)
#2. histogram of Residuals
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
hist(regPageviews2$residuals, main="Histogram of Residuals", xlab="Residuals from Regression of Pageviews1")
shapiro.test(regPageviews2$residuals)

#3.General Regression is created here for regression of pageviews vs Expected_Pageviews2
regPageviews3 <- lm (analytics2$pageviews_general ~ analytics2$Expected_Pageviews2)
summary(regPageviews3)
names(regPageviews3)
#4. histogram of Residuals
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
hist(regPageviews$residuals, main="Histogram of Residuals", xlab="Residuals from Regression of Pageviews2")
shapiro.test(regPageviews3$residuals)
#Regression of Session Data against Expected Session Data
#1.General Regression is created here for regression of sessions vs Expected_Sessions
regSessions <- lm (analytics2$sessions ~ analytics2$Expected_sessions)
summary(regSessions)
names(regSessions)
#2. histogram of Residuals
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
hist(regSessions$residuals, main="Histogram of Residuals", xlab="Residuals from Regression of Sessions vs Expected_Sessions")
shapiro.test(regSessions$residuals)

#Adding of Expected Sessions is perfectly fine since regression shows a R2 of 1
Expected_sessions_m <- data.frame(Expected_sessions_m=(analytics2$Expected_sessions/1000000))
analytics2<-cbind(analytics2,Expected_sessions_m)

# plot of expected sessions vs sessions
plot(analytics2$Expected_sessions_m,analytics2$Expected_sessions_m, xlab=paste("No of Sessions From Analytics_daily_user Data","
(millions)"), ylab=paste("Number of Expected_sessions", "
(millions)"), main="Sessions")

# plot of expected pageviews 1 vs pageviews_general
plot(analytics2$Expected_Pageviews1,analytics2$pageviews_general, xlab=paste("No of Pageviews From Analytics_daily_Pageviews Data"), ylab=paste("Number of Expected_pageviews1"), main="Pageviews vs Expected_Pageviews1")

# plot of expected pageviews 2 vs pageviews_general
plot(analytics2$Expected_Pageviews2,analytics2$pageviews_general, xlab=paste("No of Pageviews From Analytics_daily_Pageviews Data"), ylab=paste("Number of Expected_pageviews2"), main="Pageviews vs Expected_Pageviews2")

#Overlay plot of User data and Pageview Data and Session Data and New User Data-point format
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(analytics2$date_general_google,analytics2$users_m, type="p", main ="Users and Pageviews Over Time", ylab=(paste("Number (millions)")), xlab="Year", col=c("#0000FF"), cex=0.5, ylim=c(0,14))
add=TRUE
points(analytics2$date_general_google,analytics2$New_users_m, type="p", col=c("#009999"), cex=0.5)
add=TRUE
points(analytics2$date_general_google,analytics2$pageviews_g_m, type="p",col=c("#FF00FF"), cex=0.5)
add=TRUE
points(analytics2$date_general_google,analytics2$Expected_sessions_m, type="p",col=c("#FFFF33"), cex=0.5)
legend(x="topright",
       cex=0.6,
       legend=(c("Pageviews","Total Users","New Users", "Sessions")),
       pch = 1,
       col=c("#0000FF","#FF00FF","#009999","#FFFF33"))

#Overlay plot of User data and Pageview Data and Session Data - line format 
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(analytics2$date_general_google,analytics2$users_m, type="l", main ="Users and Pageviews Over Time", ylab=(paste("Number (millions)")), xlab="Year", col=c("#0000FF"), cex=0.5, ylim=c(0,14))
add=TRUE
points(analytics2$date_general_google,analytics2$pageviews_g_m, type="l",col=c("#FF00FF"), cex=0.5)
add=TRUE
points(analytics2$date_general_google,analytics2$Expected_sessions_m, type="l",col=c("#FFFF33"), cex=0.5)
legend(x="topright",
       cex=0.6,
       legend=(c("Pageviews","Total Users","Sessions")),
       lty= 1,
       col=c("#FF00FF","#0000FF","#FFFF33"))

#Overlay plot of User data and Pageview Data and Session Data and New User Data- line format
par(cex.lab=0.6,cex.sub=0.8,cex.axis=0.8)
plot(analytics2$date_general_google,analytics2$users_m, type="l", main ="Users and Pageviews Over Time", ylab=(paste("Number (millions)")), xlab="Year", col=c("#0000FF"), cex=0.5, ylim=c(0,14))
add=TRUE
points(analytics2$date_general_google,analytics2$New_users_m, type="l", col=c("#009999"), cex=0.5)
add=TRUE
points(analytics2$date_general_google,analytics2$pageviews_g_m, type="l",col=c("#FF00FF"), cex=0.5)
add=TRUE
points(analytics2$date_general_google,analytics2$Expected_sessions_m, type="l",col=c("#FFFF33"), cex=0.5)
legend(x="topright",
         cex=0.6,
         legend=(c("Pageviews","Total Users","New Users", "Sessions")),
         lty = 1,
         col=c("#0000FF","#FF00FF","#009999","#FFFF33"))

#GGPlots
#1.Plot of users,new users, pageviews, sessions
ggplot()+geom_line(data=analytics2,aes(x=date_general_google,y=users_m),
color="red")+geom_line(data=analytics2,aes(x=date_general_google,y=New_users_m),
color="orange")+geom_line(data=analytics2,aes(x=date_general_google,y=pageviews_g_m),
color="blue")+geom_line(data=analytics2,aes(x=date_general_google,y=Expected_sessions_m),
color=("green"))+xlab("Date")+ylab("Numbers (million)")

#2.Plot of users,pageviews, sessions
ggplot()+geom_line(data=analytics2,aes(x=date_general_google,y=users_m),
color="red")+geom_line(data=analytics2,aes(x=date_general_google,y=pageviews_g_m),
color="blue")+geom_line(data=analytics2,aes(x=date_general_google,y=Expected_sessions_m),
color=("green"))+xlab("Date")+ylab("Numbers (million)")

#3.Plot of users,pageviews
ggplot()+geom_line(data=analytics2,aes(x=date_general_google,y=users_m),
color="red")+geom_line(data=analytics2,aes(x=date_general_google,y=pageviews_g_m),
color="blue")+xlab("Date")+ylab("Numbers (million)")

#4.Interactive plot Users and Pageviews 
Interactive_plot_Users_Pageviews<- ggplot()+geom_line(data=analytics2,aes(x=date_general_google,y=users_m),color="red")+geom_line(data=analytics2,aes(x=date_general_google,y=pageviews_g_m),
color="blue")+xlab("Date")+ylab("Numbers (million)")
ggplotly(Interactive_plot_Users_Pageviews)

#Importing Test data
allTests <- read.csv("C:/Users/Gokhan Mutlu/Desktop/datathon/allTests.csv")
names(allTests)
attach(allTests)

#Test Group summarizes and basic stats
#Group summary by test type
group_by(allTests,TestType) %>% summarise (count = n(), mean = mean(clickrateIncFromAverage, na.rm = TRUE), sd = sd(clickrateIncFromAverage, na.rm = TRUE), median = median(clickrateIncFromAverage, na.rm = TRUE), IQR = IQR(clickrateIncFromAverage, na.rm = TRUE))
# 3 way Kruskal Wallis for testing if the clickrateIncFrom average is different in H, I, C ie headline, image and combination tests 
kruskal.test(clickrateIncFromAverage ~ TestType, data=allTests)

#Recoding the test variable into numbers 
vTestType <- recode(allTests$TestType, "H" = 1, "I" = 2, "C" = 3) 

#creating a new dataset with numeric variable encoding test type
allTests2<-cbind(allTests,vTestType)
typeof(allTests2$vTestType)
typeof(allTests2$clickrateIncFromAverage)
attach(allTests2)

#Creating subsets of data to do 2 way comparisons with Mann Whitney U or wilcoxon test between the subgroups of H, I, and C
alltests2HI<-filter (allTests2, vTestType < "3") 
head(alltests2HI)
attach(alltests2HI)
wilcox.test(alltests2HI$clickrateIncFromAverage ~ alltests2HI$vTestType, alternative = "two.sided", paired = FALSE)

alltests2IC<-filter (allTests2, vTestType !=1) 
head(alltests2IC)
attach(alltests2IC)
wilcox.test(alltests2IC$clickrateIncFromAverage ~ alltests2IC$vTestType, alternative = "two.sided", paired = FALSE)

alltests2HC<-filter (allTests2, vTestType !=2) 
head(alltests2HC)
attach(alltests2HC)
wilcox.test(alltests2HC$clickrateIncFromAverage ~ alltests2HC$vTestType, alternative = "two.sided", paired = FALSE)

#Looking at whether posted and not posted tests differ 
wilcox.test(allTests2$clickrateIncFromAverage ~ allTests2$posted, alternative = "two.sided", paired = FALSE)
boxplot(data=allTests2, clickrateIncFromAverage ~ posted)
wilcox.test(allTests2$testcount ~ allTests2$posted, alternative = "two.sided", paired = FALSE)
boxplot(data=allTests2, testcount ~ posted)
xtabs(~posted + TestType, data= allTests2) 
chisq.test(allTests2$vTestType,allTests2$posted)

#creating just a dataset of posted tests since this is most relevant to outcomes related pageviews and users 
allTests2Posted<-filter (allTests2, posted == "True")

#aggregating daily data
#first create numeric variables
n_imagetest <- recode(allTests2Posted$imagetest, "False" = 0, "True" = 1)
n_headlinetest <- recode(allTests2Posted$headlinetest, "False" = 0, "True" = 1)
allTests2Posted<-cbind(allTests2Posted,n_imagetest,n_headlinetest)
n_combinedtest<-(n_imagetest+n_headlinetest -1)
allTests2Posted<-cbind(allTests2Posted,n_combinedtest)
n_totaltest<-(n_imagetest+n_headlinetest-n_combinedtest)
allTests2Posted<-cbind(allTests2Posted,n_totaltest)

#number of each tests each day and other test attributes and creating a combined test dataframe by date
dailyimagetest<-aggregate(n_imagetest ~ date, data=allTests2Posted, FUN = sum )
dailyheadlinetest<-aggregate(n_headlinetest ~ date, data=allTests2Posted, FUN = sum )
dailycombinedtest<-aggregate(n_combinedtest ~ date, data=allTests2Posted, FUN = sum )
dailytotaltest<-aggregate(n_totaltest ~ date, data=allTests2Posted, FUN = sum )
dailytotaltestoptions<-aggregate(testcount ~ date, data=allTests2Posted, FUN = sum )
dailytotalclickrateIncFromAverage <-aggregate(clickrateIncFromAverage ~ date, data=allTests2Posted, FUN = sum)
dailytest<-merge.data.frame(dailyimagetest,dailyheadlinetest,by.x="date")
dailytest<-merge.data.frame(dailytest,dailycombinedtest,by.x="date")
dailytest<-merge.data.frame(dailytest,dailytotaltest,by.x="date")
dailytest<-merge.data.frame(dailytest,dailytotaltestoptions,by.x="date")
dailytest<-merge.data.frame(dailytest,dailytotalclickrateIncFromAverage,by.x="date")

#creating a combined test and other outcomes dataframe by date
date2<-as.Date(dailytest$date)
date3<-as.Date(analytics2$date_general_google)
analytics2<-cbind(analytics2,date3)
dailytest<-cbind(dailytest,date2)
combined<-merge.data.frame(analytics2,dailytest,by.x="date3", by.y="date2", all.x=TRUE, all.y=TRUE)

names(combined)

#plotting combined dataset
#1. user,sessions,pageviews
ggplot()+geom_point(data=combined,aes(x=date_general_google,y=users_m),
color="red")+geom_point(data=combined,aes(x=date_general_google,y=pageviews_g_m),
color="blue")+geom_point(data=combined,aes(x=date_general_google,y=Expected_sessions_m),
color=("green"))+xlab("Date")+ylab("Numbers (million)")

#2.user and tests
ggplot()+geom_point(data=combined,aes(x=date_general_google,y=users_m),
color="red")+geom_point(data=combined,aes(x=date_general_google,y=n_imagetest),
color="blue")+geom_point(data=combined,aes(x=date_general_google,y=n_headlinetest),
color=("green"))+xlab("Date")+ylab("Numbers")

#3.user and headline test
ggplot()+geom_point(data=combined,aes(x=date_general_google,y=users_m),
color="red")+geom_line(data=combined,aes(x=date_general_google,y=n_headlinetest),
color=("green"))+xlab("Date")+ylab("Numbers")

#4. user and imagetest
ggplot()+geom_point(data=combined,aes(x=date_general_google,y=users_m),
color="red")+geom_line(data=combined,aes(x=date_general_google,y=n_imagetest),
color="blue")+xlab("Date")+ylab("Numbers")

#5.user and combined test
ggplot()+geom_point(data=combined,aes(x=date_general_google,y=users_m),
color="red")+geom_line(data=combined,aes(x=date_general_google,y=n_combinedtest),
color="lightblue")+xlab("Date")+ylab("Numbers")

#6.user and total test
ggplot()+geom_point(data=combined,aes(x=date_general_google,y=users_m),
color="red")+geom_line(data=combined,aes(x=date_general_google,y=n_totaltest),
color="yellow")+xlab("Date")+ylab("Numbers")

#7.user and testcount
ggplot()+geom_point(data=combined,aes(x=date_general_google,y=users_m),
color="red")+geom_line(data=combined,aes(x=date_general_google,y=n_totaltest),
color="yellow")+xlab("Date")+ylab("Numbers")

#incorporate new data - this is dataset (timeseriesoftests) counts each day seperately if a test is run over two days, the other dataset (alltests2Posted) has collapsed the outcome of the test into 1st test
#as such the unique days differ in the two sets
timeseriesoftests <- read.csv("C:/Users/Gokhan Mutlu/Desktop/datathon/timeseriesoftests.csv")
View(timeseriesoftests)
typeof(timeseriesoftests$created_at)
date_4<-as.Date (timeseriesoftests$created_at)
newallTestData <-cbind(timeseriesoftests,date_4)
combined2 <-merge.data.frame(combined,newallTestData,by.x="date3", by.y="date_4", all.x=TRUE, all.y=TRUE)

#generate new plots for combined data 2 which now has 39 variables
#1. plot of users vs imagetests
ggplot()+geom_point(data=combined2,aes(x=date3,y=users_m),
color="red")+geom_line(data=combined2,aes(x=date3,y=NITests),
color="blue")+xlab("Date")+ylab("Numbers")

#scaling the variables to explore relationships
names(combined2)
scale2 <- function(x, na.rm = FALSE) (x - mean(x, na.rm = na.rm)) / sd(x, na.rm)
scaledcombined2<- combined2 %>% mutate(across(where(is.numeric), ~ scale2(.x, na.rm = TRUE)))

#plotting scaled variables in dataset
#1. scaled users_m and whether any image test ( combined or single image) has been performed on that day
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=n_imagetest),
                                           color="blue")+xlab("Date")+ylab("Numbers") 

#2.scaled users_m and whether any combined test has been performed on that day
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=n_combinedtest),
                                           color="lightgreen")+xlab("Date")+ylab("Numbers") 

#3.scaled users_m and whether any headline test has been performed on that day
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=n_combinedtest),
                                           color="yellow")+xlab("Date")+ylab("Numbers")

#4.scaled user_m and N of winners
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=NofWinners),
                                           color="purple")+xlab("Date")+ylab("Numbers")

#5. scaled user_m and WinnerITests
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=WinnerITests),
                                           color="green")+xlab("Date")+ylab("Numbers")
#6. scaled user_m and WinnerCtests
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=WinnerCTests),
                                           color="slateblue4")+xlab("Date")+ylab("Numbers")
#7. scaled users,pageviews,sessions,newusers
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),color="red")+geom_point(data=scaledcombined2,aes(x=date3,y=New_users_m),
color=("orange"))+geom_point(data=scaledcombined2,aes(x=date3,y=pageviews_g_m),
color=("blue"))+geom_point(data=scaledcombined2,aes(x=date3,y=Expected_sessions_m),
color=("green"))+xlab("Date")+ylab("Numbers")

#8. scaled user_m n_image_tests
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=n_imagetest),
                                           color="lightblue")+xlab("Date")+ylab("Numbers")

#9.scaled users vs max_clicks
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=maximalclicks),
                                           color="purple")+xlab("Date")+ylab("Numbers")

##create new variable of AnyImageWinner
WinnerAnyImageTesting<-combined2$WinnerITests+combined2$WinnerCTests
WinnerAnyImageTesting <-scale2(WinnerAnyImageTesting, na.rm = TRUE)
additionalVarscaled<-cbind(date3,WinnerAnyImageTesting) #generated to check if WinnerAnyImageTesting has been correctly scaled

#1. Append new Any Image variable to scaledcombined2
scaledcombined2<-cbind(scaledcombined2,WinnerAnyImageTesting)

#9. scaled user_m and winneranyimagetesting
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m),
                    color="red")+geom_line(data=scaledcombined2,aes(x=date3,y=WinnerAnyImageTesting),
                                           color="turquoise")+xlab("Date")+ylab("Numbers")

#10.Plot of scaled users,new users, pageviews, sessions with legend
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m,color="Users"))+geom_point(data=scaledcombined2,aes(x=date3,y=New_users_m,
color="New_users"))+geom_point(data=scaledcombined2,aes(x=date3,y=pageviews_g_m,color="Pageviews"))+geom_point(data=scaledcombined2,aes(x=date3,y=Expected_sessions_m,
color="Sessions"))+xlab("Date")+ylab("Numbers")+ labs(colour="")+scale_color_manual(labels=c("Users","New_users","Pageviews","Sessions"), 
values=c("Users"="red","New_users"="orange","Pageviews"="blue","Sessions"="green"))

#11.Plot users and image test winners
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m, color="Users"))+geom_line(data=scaledcombined2,
aes(x=date3,y=WinnerAnyImageTesting,color="Image_Test_Winners")) + xlab("Date") + ylab("Numbers")+labs(colour="")+ scale_color_manual(labels=c("Users","Image_Test_Winners"), 
values=c("Users"="red","Image_Test_Winners"="green"))

#12. Plot users and n_imagetests
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m, color="Users"))+geom_line(data=scaledcombined2,
aes(x=date3,y=n_imagetest,color="Tests_with_images")) + xlab("Date") + ylab("Numbers")+labs(colour="")+ scale_color_manual(labels=c("Users","Tests_with_images"), 
values=c("Users"="red","Tests_with_images"="lightblue"))

#13. Plot users and maxclicks
ggplot()+geom_point(data=scaledcombined2,aes(x=date3,y=users_m, color="Users"))+geom_line(data=scaledcombined2,
aes(x=date3,y=n_imagetest,color="Max_Clicks")) + xlab("Date") + ylab("Numbers")+labs(colour="")+ scale_color_manual(labels=c("Users","Max_Clicks"),values=c("Users"="red","Max_Clicks"="purple"))

# create variable for nonscaled winner any image test
NonscaledWinnerAnyImageTesting<-(combined2$WinnerITests+combined2$WinnerCTests)


##Time SERIES STUFF
#stochastic events modeling general approach
set.seed(111)
Random_Walk <- arima.sim(n = 850, model = list(order = c(0,1,0)))

Random_Walk_diff <- diff(Random_Walk)

#time series plot of users shows altering variations over time 
plot.ts(scaledcombined2$users_m,
        main="Number of Users",
        col="red",ylab="Scaled number of Users")

#log normalization of users to reduce changes in variance over time
lognumberusers<-log(combined2$users)
plot.ts(lognumberusers,
        main="Number of Users",
        col="red",ylab="Log number of Users")

#time series plot of n_imagetests shows altering variations over time 
plot.ts(scaledcombined2$n_imagetest,
        main="Number of Tests_With_Images",
        col="lightblue",ylab=" Scaled Tests_With_Images")

#log normalization of n_imagetests to reduce changes in variance over time
lognumbern_imagetest<-log(combined2$n_imagetest)
plot.ts(lognumbern_imagetest,
        main="Number of Tests_With_Images",
        col="lightblue",ylab="Log Tests_With_Images", ylim=c(0,6))


#time series plot of winner any image testing shows altering variations over time 
plot.ts(scaledcombined2$WinnerITests,
        main="Number of Image Test Winners",
        col="green",ylab=" Scaled Image_Test_Winners")

#log normalization of n_imagetests to reduce changes in variance over time
logWinnerITest<-log(combined2$WinnerITests)
plot.ts(lognumbern_imagetest,
        main="Number of Image Test Winners",
        col="green",ylab="Log Image_Test_Winners", ylim=c(0,6))

#time series plot of max clicks shows altering variations over time 
plot.ts(scaledcombined2$maximalclicks,
        main="Number of Maximal Clicks",
        col="purple",ylab="Max_Clicks")

#log normalization of max clicks to reduce changes in variance over time
logmax_click<-log(combined2$maximalclicks)
plot.ts(lognumbern_imagetest,
        main="Number of Maximal Clicks",
        col="purple",ylab="Log Max_Clicks",  ylim=c(0,5))

#differencing and plots
lognumbern_imagetest_diff <- diff(lognumbern_imagetest)
logWinnerITest_diff<-diff(logWinnerITest)
lognumberusers_diff<-diff(lognumberusers)
logmax_click_diff<-diff(logmax_click)
plot.ts(lognumbern_imagetest_diff,
        main="Number of Tests_With_Images",
        col="lightblue",ylab="Diff Tests_With_Images")
plot.ts(lognumbern_imagetest_diff,
        main="Number of Image Test Winners",
        col="green",ylab="Diff Image_Test_Winners")
plot.ts(lognumberusers_diff,
        main="Number of Users",
        col="red",ylab="Diff number of Users")
plot.ts(logmax_click_diff,
        main="Number of Max_Clicks",
        col="purple",ylab="Diff number of MaxClicks")

install.packages("tseries")
library(tseries)
install.packages("IDPmisc")
library(IDPmisc)

#Testing for stationarity
#1. removing missing and doing KPSS test
m_lognumbern_imagetest_diff <- NaRV.omit(lognumbern_imagetest_diff)
m_logWinnerITest_diff <- NaRV.omit(logWinnerITest_diff)
m_lognumberusers_diff <- NaRV.omit(lognumberusers_diff)
m_logmax_clicks_diff<-NaRV.omit(logmax_click_diff)
kpss.test(m_lognumbern_imagetest_diff, null = "Level")
kpss.test(m_logWinnerITest_diff, null = "Level")
kpss.test(m_lognumberusers_diff, null = "Level")
kpss.test(m_logmax_clicks_diff, null = "Level")

#making a new array of log values added and creating a time series with the 4 pieces of data with date3
combined3<-as.ts(cbind (scaledcombined2$date3, lognumbern_imagetest, logWinnerITest, lognumberusers, logmax_click))
diff_combined3<-diff(combined3)
diff_combined3<-NaRV.omit(diff_combined3)

combined4 <-as.ts(cbind (scaledcombined2$date3, lognumbern_imagetest, logWinnerITest, lognumberusers, logmax_click))
combined5 <cbind (scaledcombined2$date3, lognumbern_imagetest, logWinnerITest, lognumberusers, logmax_click)
ts_users<-as.ts(cbind(scaledcombined2$date3,lognumberusers))
ts_maxclick<-as.ts(cbind(scaledcombined2$date3,logmax_click))
ts_winnerItest<-as.ts(cbind(scaledcombined2$date3,logWinnerITest))
ts_n_imagetest<-as.ts(cbind(scaledcombined2$date3,lognumbern_imagetest))
ts2_users<-as.ts(lognumberusers)
ts2_maxclick<-as.ts(logmax_click)
ts2_winnerITest<-as.ts(logWinnerITest)
ts2_n_imagetest<-as.ts(lognumbern_imagetest)
              
install.packages("forecast")
library(forecast)

#dealing with missing data  using forecast's ba.interp method
ts3_users<-na.interp(ts2_users)
ts3_maxclick<-na.interp(ts2_maxclick)
ts3_WinnerITest<-na.interp(ts2_winnerITest)
ts3_n_imagetest<-na.interp(ts2_n_imagetest)

#making arima models using log values 
arima_users <- auto.arima(ts3_users)
arima_maxclick <-auto.arima(ts3_maxclick)
arima_WinnerITest<-auto.arima(ts3_WinnerITest)
arima_n_imagetest<-auto.arima(ts3_n_imagetest)

#arima residuals of models using log values 
#1.User ARIMA model
layout(matrix(c(1,2,3,3), nrow = 2))
acf(arima_users$residuals)
pacf(arima_users$residuals)
hist(arima_users$residuals, main = "Histogram of residuals - ARIMA Users")

#2.number of clicks ARIMA model
layout(matrix(c(1,2,3,3), nrow = 2))
acf(arima_maxclick$residuals)
pacf(arima_maxclick$residuals)
hist(arima_maxclick$residuals, main = "Histogram of residuals - ARIMA Max_Click")

#3. residual tests
checkresiduals(arima_users)
checkresiduals(arima_maxclick)

#arima residuals of models using log and diff values 
ts4_users<-as.ts(lognumberusers_diff)
ts4_maxclick<-as.ts(logmax_click_diff)
ts4_winnerITest<-as.ts(logWinnerITest_diff)
ts4_n_imagetest<-as.ts(lognumbern_imagetest_diff)
ts5_users<-na.interp(ts4_users)
ts5_max_click<-na.interp(ts4_maxclick)
ts5_winnerITest<-na.interp(ts4_winnerITest)
ts5_n_imagetest<-na.interp(ts4_n_imagetest)
ts6_winnerIT_test<-NaRV.omit(as.numeric (ts5_winnerITest)) # trying to test here how much of the data needs removal

arima_users2 <- auto.arima(ts5_users)
arima_maxclick2 <-auto.arima(ts5_max_click)
arima_WinnerITest2<-auto.arima(ts5_winnerITest)
arima_n_imagetest2<-auto.arima(ts5_n_imagetest)

checkresiduals(arima_users2)
checkresiduals(arima_maxclick2)

res_arima_users2 <- arima_users2$residuals
res_arima_maxclick2 <- arima_maxclick2$residuals

library(forecast)

# Fitting the arima model of users to max_clicks and examining correlation of residuals of users and new fitted maxClick model
#with the high autocorrelation this complex modeling does ot yield prewhitened data as expected unfortunately
arima_maxclick3 <-Arima(ts5_max_click,model=arima_users2)
res_arima_maxclick3 <- arima_maxclick3$residuals
ccf(res_arima_users2,res_arima_maxclick3)

install.packages("TSA")
library(TSA)

#prewhitening using different models in TSA package
prewhiten(ts5_users,ts5_max_click)



