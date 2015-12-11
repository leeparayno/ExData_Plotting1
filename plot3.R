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

## Create png of 480x480
png(filename="plot3.png", width = 480, height = 480)

## Plot of Energy sub metering
#dates = as.Date(powerCleanDates$Date, format = "%d/%m/%Y %H:%M:%S")
with(powerCleanDates, plot(powerCleanDates$Date, powerCleanDates$Sub_metering_1, col = "black", type = "l", xlab = "", ylab = "Energy sub metering"))
lines(powerCleanDates$Date, powerCleanDates$Sub_metering_2, col = "red")
lines(powerCleanDates$Date, powerCleanDates$Sub_metering_3, col = "blue")
legend("topright", lty = c(1, 1, 1), lwd = c(2, 2, 2), col = c("black","red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()
