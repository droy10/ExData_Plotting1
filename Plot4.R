# First we download and unzip the (full) data set, in the working directory:
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "household_power_consumption.zip", method = "curl")
unzip("household_power_consumption.zip", exdir = ".")

# We create a data frame with the full dataset:
hpc_full <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")

# We create a subset with only the 2 dates that interest us:
hpc_subset <- subset(hpc_full, Date == "1/2/2007" | Date == "2/2/2007")

# We create a new DateTime variable, to be the x-axis of the graph:
hpc_subset$DateTime <- as.POSIXct(paste(hpc_subset$Date, hpc_subset$Time), format = "%d/%m/%Y %H:%M:%S")

# We use the "stringi" library to easily trim spaces in the "Global Active Power" field:
library(stringi)

hpc_subset$Sub_metering_1 <- as.numeric(stri_trim_both(hpc_subset$Sub_metering_1))
hpc_subset$Sub_metering_2 <- as.numeric(stri_trim_both(hpc_subset$Sub_metering_2))
hpc_subset$Sub_metering_3 <- as.numeric(stri_trim_both(hpc_subset$Sub_metering_3))
hpc_subset$Voltage <- as.numeric(stri_trim_both(hpc_subset$Voltage))
hpc_subset$Global_reactive_power <- as.numeric(stri_trim_both(hpc_subset$Global_reactive_power))

# We open a new device, to write to the png file:
png("plot4.png", width = 480, height = 480)

# We want 4 graphs displayed, 2 per row:
par("mfrow" = c(2, 2))

# First graph:
plot(hpc_subset$DateTime, as.numeric(stri_trim_both(hpc_subset[, 3])),
     main = NULL,
     ylab = "Global Active Power (kilowatts)",
     xlab = "",
     type = "l")

# Second graph:
plot(hpc_subset$DateTime, as.numeric(stri_trim_both(hpc_subset[, 5])),
     main = NULL,
     ylab = "Voltage",
     xlab = "datetime",
     type = "l")

# Third graph:
plot(Sub_metering_1 + Sub_metering_2 + Sub_metering_3 ~ DateTime,
     data = hpc_subset,    
     main = NULL,
     ylab = "Energy sub metering",
     xlab = "",
     type = "n",
     ylim = c(0,39))

lines(Sub_metering_1 ~ DateTime, data = hpc_subset, col = "black")
lines(Sub_metering_2 ~ DateTime, data = hpc_subset, col = "red")
lines(Sub_metering_3 ~ DateTime, data = hpc_subset, col = "blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd=1, lty=c(1, 1, 1), col=c("black", "red", "blue"))

# Fourth graph:
plot(hpc_subset$DateTime, as.numeric(stri_trim_both(hpc_subset[, 4])),
     main = NULL,
     ylab = "Global_reactive_power",
     xlab = "datetime",
     type = "l")

dev.off()
