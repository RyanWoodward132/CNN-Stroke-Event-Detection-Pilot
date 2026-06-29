# JD.R
# This file contains the R code used to process the raw accelerometer data of JD
# This file contains the R code used to process the event data of JD

#+ Load Libraries
library(readr)
library(lubridate)
library(tidyverse)
library(ggplot2)
library(patchwork)
library(stringr)

#+ Import data
acc = read.csv("Data/Raw/Temp/Accel/JD.csv")

#+ Convert acc$Time to elapsed time in sec from first timestamp
acc$Time = dmy_hms(acc$Time)
acc$Time = round(as.numeric(difftime(acc$Time, acc$Time[1], units = "secs")), 2)

#+ Export acc to Data/Raw/Accel
write.csv(acc, file = "Data/Raw/Accel/JD.csv")
