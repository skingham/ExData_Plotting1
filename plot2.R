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
pwr$DateTime <- strptime(paste(pwr$Date, pwr$Time), "%d/%m/%Y %H:%M:%S")

# Get relevant data points into a new data frame
vals <- data.frame(DateTime=pwr$DateTime, Global_active_power=pwr$Global_active_power)

png('plot2.png', width=480, height=480, units="px")
plot(vals, type="l", ylab="Global Active Power (kilowatts)", xlab="")
dev.off()
