# AC.R
# This file contains the R code used to process the RAW accelerometer data of AC
# This file contains the R code used to process the Event data of AC

#+ Load Libraries
library(readr)
library(lubridate)
library(tidyverse)
library(ggplot2)
library(patchwork)
library(stringr)

#+ Import Data
acc = read.csv("Data/Raw/Temp/Accel/AC.csv")

#+ Convert acc$Time to elapse time in seconds from first timestamp
acc$Time = dmy_hms(acc$Time)
acc$Time = round(as.numeric(difftime(acc$Time, acc$Time[1], units = "secs")), 2)

#+ Export acc to Data/Raw/Accel
write.csv(acc, file = "Data/Raw/Accel/AC.csv")

