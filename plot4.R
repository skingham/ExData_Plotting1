# Find all lines of the correct date range
greplines <- grep('^[1-2]/2/2007', readLines('household_power_consumption.txt'))
firstDateRangeLine <- greplines[1]
dateRangeCount <- length(greplines)

# Read in the file, skipping to the first line of our date range, and only reading in the correct number of lines 
colNames <- c('Date', 'Time', 'Global_active_power', 'Global_reactive_power', 'Voltage', 'Global_intensity', 'Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
pwr <- read.csv('household_power_consumption.txt', 
                header=FALSE, sep=';', 
                col.names=colNames, 
                colClasses=c('character', 'character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'), 
                skip=firstDateRangeLine-1, 
                nrows=dateRangeCount)

# Construct a correct date from date and time strings
pwr$datetime <- strptime(paste(pwr$Date, pwr$Time), "%d/%m/%Y %H:%M:%S")

# Get relevant data points into a new data frame
sub1 <- data.frame(datetime=pwr$datetime, Sub_metering_1=pwr$Sub_metering_1)
sub2 <- data.frame(datetime=pwr$datetime, Sub_metering_2=pwr$Sub_metering_2)
sub3 <- data.frame(datetime=pwr$datetime, Sub_metering_3=pwr$Sub_metering_3)
gap <- data.frame(datetime=pwr$datetime, Global_active_power=pwr$Global_active_power)
volt <- data.frame(datetime=pwr$datetime, Voltage=pwr$Voltage)
grp <- data.frame(datetime=pwr$datetime, Global_reactive_power=pwr$Global_reactive_power)



png('plot4.png', width=480, height=480, units="px")
par(mfrow=c(2,2))
plot(gap, type="l", ylab="Global Active Power", xlab="")
plot(volt, type="l", ylab="Voltage")
plot(sub1, type="l", ylab="Energy sub metering", xlab="")
lines(sub2, col="red")
lines(sub3, col="blue")
legend("topright", c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), box.lwd= 0, lty=c(1,1), col=c("black", "red", "blue"))
plot(grp, type="l")
dev.off()
