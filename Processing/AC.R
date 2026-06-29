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

#+ Creating new features
# We want to calculate Jerk and absolute Jerk as additional variables
# Jerk is the time-derivative of acceleration (da/dt), computed per axis.
# Per-axis jerk = diff(acceleration) / diff(Time); first row has no prior, so NA.
acc$jerkV = c(NA, diff(acc$Vertical) / diff(acc$Time))
acc$jerkL = c(NA, diff(acc$Lateral)  / diff(acc$Time))
acc$jerkS = c(NA, diff(acc$Sagittal) / diff(acc$Time))

# Jerk: resultant magnitude of the three per-axis jerks
acc$JerkMag = sqrt(acc$jerkV^2 + acc$jerkL^2 + acc$jerkS^2)

# Absolute Jerk: sum of the absolute per-axis jerks
acc$AbsJerk = abs(acc$jerkV) + abs(acc$jerkL) + abs(acc$jerkS)

#+ Export acc to Data/Raw/Accel
write.csv(acc, file = "Data/Raw/Accel/AC.csv")

#+ Graph acceleration axes vs time
p_vert = ggplot(acc, aes(x = Time, y = Vertical)) +
  geom_line(colour = "#2196F3") +
  labs(x = NULL, y = "Vertical") +
  theme_minimal()

p_lat = ggplot(acc, aes(x = Time, y = Lateral)) +
  geom_line(colour = "#4CAF50") +
  labs(x = NULL, y = "Lateral") +
  theme_minimal()

p_sag = ggplot(acc, aes(x = Time, y = Sagittal)) +
  geom_line(colour = "#F44336") +
  labs(x = "Time (s)", y = "Sagittal") +
  theme_minimal()

p_vert / p_lat / p_sag

#+ Graph jerk axes and magnitude vs time
j_sag = ggplot(acc, aes(x = Time, y = jerkS)) +
  geom_line(colour = "#F44336") +
  labs(x = NULL, y = "Jerk Sagittal") +
  theme_minimal()

j_vert = ggplot(acc, aes(x = Time, y = jerkV)) +
  geom_line(colour = "#2196F3") +
  labs(x = NULL, y = "Jerk Vertical") +
  theme_minimal()

j_lat = ggplot(acc, aes(x = Time, y = jerkL)) +
  geom_line(colour = "#4CAF50") +
  labs(x = NULL, y = "Jerk Lateral") +
  theme_minimal()

j_mag = ggplot(acc, aes(x = Time, y = JerkMag)) +
  geom_line(colour = "#9C27B0") +
  labs(x = "Time (s)", y = "Jerk Magnitude") +
  theme_minimal()

j_sag / j_vert / j_lat / j_mag

