##library for working with data.frames in a more natural way
library(dplyr)
# record name of file in current working directory containing data
fileName <- "household_power_consumption.txt"
##If file does not exist then leave error message and stop
if(!file.exists(fileName)){
    stop("Unable to find file ",fileName,call. = FALSE)
}
## read in first line of file and use it to record the names
powerData <- read.delim(file = fileName,nrows=1,sep = ";",stringsAsFactors = FALSE)
colNames <- names(powerData)
## read in the file section containing the requested data, and then apply the names from the previous 
## step.  Only needed if you skip lines but doesn't hurt otherwise
## the skip and nrows parameters applies to the Electric power consumption [20Mb] dataset
## downloaded August 7, 2015 from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## If reading fresh data where unsure of where the data is, remove both parameters
##This will read the entire dataset, much slower but ensures full coverage
powerData <- read.delim(file = fileName,skip=66636,nrows=3000,sep = ";",stringsAsFactors = FALSE)
names(powerData) <- colNames
## Create new DateTime variable as a combination of the existing Date & Time variables
## and subset  only Febuary 1st and 2nd 2007 data
powerData <- powerData %>% mutate(DateTime = paste(Date,Time)) %>%
    filter(Date %in% "1/2/2007" | Date %in% "2/2/2007")
## convert DateTime to POSIX format
powerData$DateTime <- strptime(powerData$DateTime,"%d/%m/%Y %H:%M:%S")
## Draw plot on Global_active_power
plot(powerData$Global_active_power,x = powerData$DateTime, type = "l",xlab = "", ylab = "Global Active Power (kilowatts)")
## Copy the plot to a png file and close the file
dev.copy(png, file = "plot2.png", width = 480, height = 480) ## Copy plot to a PNG file
dev.off() ## close PNG device

