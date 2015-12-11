library(sqldf)
library(lubridate)

powerFile = "household_power_consumption.txt"

setup <- function() {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "exdata.zip", method = "curl")
    unzip("exdata.zip")
}

if (!file.exists(powerFile)) {
    setup()
}

power <- read.csv.sql(powerFile, sql = "SELECT * FROM file WHERE Date in ('1/2/2007','2/2/2007')", header = TRUE, sep = ";")
closeAllConnections()
dates <- dmy_hms(paste(power$Date,power$Time))

powerCleanDates <- data.frame(Date = dates, power[,3:length(power)])

## Global Active Power plot
## Create png of 480x480
png(filename="plot1.png", width = 480, height = 480)

## Plot histogram of Global Active Power 
hist(powerCleanDates[,2], col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

## Fix labels
axis(2, at = c(200,400,600,800,1000,1200), labels = c("200","400","600","800","1000","1200"))
dev.off()
