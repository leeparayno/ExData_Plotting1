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

power <- read.csv.sql(powerFile, sql = "select * from file WHERE Date in ('1/2/2007','2/2/2007')", header = TRUE, sep = ";")
closeAllConnections()
dates <- dmy_hms(paste(power$Date,power$Time))

powerCleanDates <- data.frame(Date = dates, power[,3:length(power)])

## Create png of 480x480
png(filename="plot4.png", width = 480, height = 480)

## Plot of Energy sub metering
par(mfrow = c(2, 2))

## Global Active Power
plot(powerCleanDates$Global_active_power ~ powerCleanDates$Date, ylab = "Global Active Power",xlab = "", type = "n")
lines(powerCleanDates[,1:2], type = "l")

## Voltage
plot(powerCleanDates$Voltage ~ powerCleanDates$Date, ylab = "Voltage",xlab = "datetime", type = "n")
lines(powerCleanDates[,c(1,4)], type = "l")

## Energy Sub Metering
with(powerCleanDates, plot(powerCleanDates$Date, powerCleanDates$Sub_metering_1, col = "black", type = "l", xlab = "", ylab = "Energy sub metering"))
lines(powerCleanDates$Date, powerCleanDates$Sub_metering_2, col = "red")
lines(powerCleanDates$Date, powerCleanDates$Sub_metering_3, col = "blue")
legend("topright", bty = "n", cex = 0.90, lty = c(1, 1, 1), lwd = c(2, 2, 2), col = c("black","red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

## Global reactive power
plot(powerCleanDates$Global_reactive_power ~ powerCleanDates$Date, ylab = "Global_reactive_power",xlab = "datetime", type = "n")
lines(powerCleanDates[,c(1,3)], type = "l")

dev.off()
