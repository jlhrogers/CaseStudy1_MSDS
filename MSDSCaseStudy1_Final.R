
#download the files to csv

library(downloader)
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", destfile="GDP.csv")
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile="EducData.csv")


#read csv files
gdpraw <- read.csv("GDP.csv")
eduraw <- read.csv("EducData.csv")


#select columns 1, 2, 4 and 5 from gdpraw and assign column names
edudata <- eduraw
gdpdata = gdpraw[,c(1,2,4,5)]
names(gdpdata) <- c("countrycode", "ranking", "countryname", "gdp")

#Cleanup for gdp and edu data to omit null or empty country codes
gdpclean <- gdpdata[!is.null(gdpdata$countrycode),]
educlean <- edudata[!is.null(edudata$CountryCode),]
gdpclean <- gdpclean[-which(gdpclean$countrycode==""),]
gdpclean <- gdpclean[-which(gdpclean$ranking==""),]

#assign ranking with string to int
gdpclean$ranking <- strtoi(gdpclean$ranking)


#merge data toghether by country code
MergedData <- merge(gdpclean, educlean, by=1)


##Case Study Questions and Answers

#1 Find he number of matching country codes
#  Number of records that match
length(MergedData$countrycode)
## Answer: 189

#2  Sort the data frame and find the 13th country
# 	Cast GDP as number and remove commas, then order by GDP to find the thirteenth position 
MergedData$GDPNUM <- as.numeric(gsub(",","", MergedData$gdp))
sortOrder <- MergedData[order(MergedData$GDPNUM),]
sortOrder[13, "Short.Name"]
## Answer: St. Kitts and Nevis


#3 Find the average GDP rankings of the High Income OECD and High Income Non OECD groups
#	 Assigne the groups and get the means
highIncome <- MergedData[MergedData$Income.Group == 'High income: OECD',]
nonHighIncome <- MergedData[MergedData$Income.Group == 'High income: nonOECD',]

mean(highIncome$ranking)
#Answer for High Income OECD: 32.96667

mean(nonHighIncome$ranking)
#Answer for High Income Non OECD: 91.91304

#4 Plot the GDP for all the countries
#Plot 1: GDP by country code and color filled by Income Group
library(ggplot2) 

MergedData$gdp2 <- as.numeric(gsub(",", "", MergedData$gdp))
GdpPlot <- ggplot(MergedData, aes(x=countrycode, 
																					 y=gdp2, colour=Income.Group)) 
print(GdpPlot + geom_point() + scale_y_continuous(trans='log2') 
			+ theme(axis.text.x = element_text(angle = 90, hjust = 1)))


#Plot 2: GDP by Income Group
ggplot(MergedData, aes(y = gdp2, x=Income.Group,fill=Income.Group)) + scale_y_log10()+ geom_point(pch = 21, size = 8, stat = "identity", 
position=position_jitter())+ scale_fill_manual(values = c("red", "orange", "green", "blue","brown"), 
na.value = "grey50" ) + theme(axis.text.x = element_text(angle = 45, hjust = 1))


#5 Cut the GDP rankings into 5 seperate quantile groups
#Determine the quantiles 
MergedData$quantile <- cut(MergedData$ranking, breaks = 5)
table(MergedData$quantile, MergedData$Income.Group)
tblData <- MergedData[MergedData$Income.Group == "Lower middle income" & MergedData$ranking <= 38,]
tblData["Short.Name"]



