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
png(filename="plot2.png", width = 480, height = 480)

## Plot line graph of Global Active Power
#dates = as.Date(powerCleanDates$Date, format = "%d/%m/%Y %H:%M:%S")
plot(powerCleanDates$Global_active_power ~ powerCleanDates$Date, ylab = "Global Active Power (kilowatts)",xlab = "", type = "n")
lines(powerCleanDates[,1:2], type = "l")
dev.off()
