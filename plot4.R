library(lubridate)  # We will use lubridate to easily convert strings into date/time

if (!file.exists("data")) dir.create("data")  # Create directory to store data if not present
if (!file.exists("figure")) dir.create("figure")  # Create directory to store figures if not present

if (!file.exists("./data/household_power_consumption.txt")) {  # Download and extract data file if
                                                               # required only        
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, "./data/household_power_consumption.zip")
        unzip("./data/household_power_consumption.zip", exdir = "data")
        }
Sys.setlocale("LC_TIME", "English")  # Using French version of Windows, therefore need to change
                                     # locale settings to display weekdays in English
classes <- sapply(read.table("./data/household_power_consumption.txt", sep = ";",  # Get col.classes
                             header = TRUE, nrows = 10), class)        # from limited sample of rows
selectedSet <- read.table("./data/household_power_consumption.txt", sep = ";",  # Read the required
                         skip = 66637, nrows = 2880, na.strings = "?",  # rows from the data file
                         col.names = c("date", 
                                      "time",
                                      "globalActivePower",
                                      "globalReactivePower",
                                      "voltage",
                                      "globalIntensity",
                                      "subMetering1",
                                      "subMetering2",
                                      "subMetering3"),
                         colClasses = classes)

dateTime <- dmy_hms(mapply(paste, selectedSet$date, selectedSet$time))  # Concatenate date and time,
selectedSet <- cbind(dateTime, selectedSet[, 3:9])  # convert to date/time and replace first two 
                                                    # columns
# Prepare plot grid:

par(mfrow = c(2, 2))
with(selectedSet, {
        plot(dateTime, globalActivePower, type = "l", xlab = "",
             ylab = "Global Active Power")
        plot(dateTime, voltage, type = "l", xlab = "datetime", ylab = "Voltage")
        plot(dateTime, subMetering1, type = "n", xlab = "", 
             ylab = "Energy sub metering")
        lines(dateTime, subMetering1, col = "black")
        lines(dateTime, subMetering2, col = "red")
        lines(dateTime, subMetering3, col = "blue")
        legend("topright", legend = c("Sub_Metering_1", "Sub_Metering_2", "Sub_Metering_3"), 
               col = c("black", "red", "blue"), lwd = 1)
        plot(dateTime, globalReactivePower, type = "l", xlab = "datetime"
             , ylab = "Global_reactive_power")
})


dev.copy(png, filename = "./figure/plot4.png")  # Copy to png file
dev.off()  # Close device
     
