### Script to generate visuals of water level at CS1, OW1 and OW2, SMP-ID = 61965
# 0.0 SETUP----

library(pwdgsi)
library(odbc)
library(lubridate)
library(tidyverse)
library(stats)
library(gridExtra)
library(grid)
library(gtable)
library(ggtext)
library(dplyr)
library(ggplot2)
library(pool)


#read data 
parent_df <- read.csv("//pwdoows/oows/Watershed Sciences/GSI Monitoring/06 Special Projects/59 Performance Evaluation of Private Sites/61965/Metric and Overtopping Plots/April_26_2024/overtop.csv")


# aggregate plots of overtopping for CS1

rainfall_overtopping_cs1 <- parent_df %>%
  filter(ow_suffix == "CS1") %>%
  filter(eventdatastart_edt > as.Date('2021-01-01')) %>%
  filter(eventdatastart_edt  < as.Date('2023-01-27') | eventdatastart_edt > as.Date('2023-11-03')) 
  

rainfall_overtopping_cs1$eventdatastart_edt <-as.Date(rainfall_overtopping_cs1$eventdatastart_edt)


#plot
# Storm Depth
plot_depth <- ggplot(rainfall_overtopping_cs1, aes(x = eventdatastart_edt, y= eventdepth_in)) +
  geom_point(aes(color = overtopping, shape = overtopping), size = 5) +
  theme(text = element_text(size = 20), axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1)) + 
  labs(x = "Date of Event", y = "Rain Event Depth (in)") + 
  geom_vline(xintercept= as.Date('2023-06-10'), color = "purple", size=2, linetype="dashed") +
  geom_hline(yintercept= 1.25, color = "black", size=2, linetype="dashed") +
  scale_x_date(date_labels="%b-%y",date_breaks  ="6 month") +
  ggtitle("CS1 Overtopping at Cardone 2015-SITE-2809-01 SB-2 (61965)- From 2021-01-01 To 2024-03-31") +
  annotate("text", x = as.Date('2021-03-20'), y = 1.2, label = "Design Storm: 1.25 in", size = 20/.pt) +
  annotate("text", x = as.Date('2023-05-01'), y = 3, label = "Pipe Jetting Occured on: June 10th 2023", size = 20/.pt) 

# Peakc Intensity
plot_peak <- ggplot(rainfall_overtopping_cs1, aes(x = eventdatastart_edt, y= eventpeakintensity_inhr)) +
  geom_point(aes(color = overtopping, shape = overtopping), size = 5) +
  theme(text = element_text(size = 20), axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1)) + 
  labs(x = "Date of Event", y = "Peak Intensity (in/hr)") + 
  geom_vline(xintercept= as.Date('2023-06-10'), color = "purple", size=2, linetype="dashed") +
  geom_hline(yintercept= 2.5, color = "brown", size=2, linetype="dashed") +
  scale_x_date(date_labels="%b-%y",date_breaks  ="6 month") +
  ggtitle("CS1 Overtopping at Cardone 2015-SITE-2809-01 SB-2 (61965)- From 2021-01-01 To 2024-03-31") +
  annotate("text", x = as.Date('2023-05-01'), y = 3, label = "Pipe Jetting Occured on: June 10th 2023", size = 20/.pt) +
  annotate("text", x = as.Date('2021-05-01'), y = 2.7, label = "Piping Max Capacity: 2.5 in/hr", size = 20/.pt) 


jetting_date <- as.Date("2023-06-10")

# stats
############################################################################### event depth

# % of total storms overtopping before jetting
total_overtop_before_jet <- rainfall_overtopping_cs1 %>%
  filter(eventdatastart_edt < jetting_date)
  
total_overtop_before_jet_percent <- (nrow(total_overtop_before_jet %>% filter(overtopping == 1))/nrow(total_overtop_before_jet))*100

# % of overtopping storms < 1.25 in event depth before jetting
smaller_design_overtop_before_jet <- rainfall_overtopping_cs1 %>%
  filter(eventdatastart_edt < jetting_date & eventdepth_in < 1.25)

smaller_design_overtop_before_jet_percent <- (nrow(smaller_design_overtop_before_jet %>% filter(overtopping == 1))/nrow(smaller_design_overtop_before_jet))*100



# % of total storms overtopping after jetting
total_overtop_after_jet <- rainfall_overtopping_cs1 %>%
  filter(eventdatastart_edt > jetting_date)

total_overtop_after_jet_percent <- (nrow(total_overtop_after_jet %>% filter(overtopping == 1))/nrow(total_overtop_after_jet))*100

# % of overtopping storms < 1.25 in event depth after jetting
smaller_design_overtop_after_jet <- rainfall_overtopping_cs1 %>%
  filter(eventdatastart_edt > jetting_date & eventdepth_in < 1.25)

smaller_design_overtop_after_jet_percent <- (nrow(smaller_design_overtop_after_jet %>% filter(overtopping == 1))/nrow(smaller_design_overtop_after_jet))*100

# % of total storms overtopping 
total_overtop <- rainfall_overtopping_cs1 

total_overtop_percent <- (nrow(total_overtop %>% filter(overtopping == 1))/nrow(total_overtop))*100


# % of overtopping storms < 1.25 in event depth
smaller_design_total_overtop <- rainfall_overtopping_cs1 %>%
  filter(eventdepth_in < 1.25)


smaller_design_total_overtop_percent <- (nrow(smaller_design_total_overtop %>% filter(overtopping == 1))/nrow(smaller_design_total_overtop))*100


############################################################################### event peak intensity 

# % of total storms overtopping before jetting
total_overtop_before_jet <- rainfall_overtopping_cs1 %>%
  filter(eventdatastart_edt < jetting_date)

total_overtop_before_jet_percent <- (nrow(total_overtop_before_jet %>% filter(overtopping == 1))/nrow(total_overtop_before_jet))*100

# % of overtopping storms < 2.5 in/hr peak intensity before jetting
smaller_peak_overtop_before_jet <- rainfall_overtopping_cs1 %>%
  filter(eventdatastart_edt < jetting_date & eventpeakintensity_inhr < 2.5)

smaller_peak_overtop_before_jet_percent <- (nrow(smaller_peak_overtop_before_jet %>% filter(overtopping == 1))/nrow(smaller_peak_overtop_before_jet))*100


# % of total storms overtopping after jetting
total_overtop_after_jet <- rainfall_overtopping_cs1 %>%
  filter(eventdatastart_edt > jetting_date)

total_overtop_after_jet_percent <- (nrow(total_overtop_after_jet %>% filter(overtopping == 1))/nrow(total_overtop_after_jet))*100

# % of overtopping storms < 2.5 in/hr peak intensity before jetting
smaller_peak_overtop_after_jet <- rainfall_overtopping_cs1 %>%
  filter(eventdatastart_edt > jetting_date & eventpeakintensity_inhr < 2.5)

smaller_peak_overtop_after_jet_percent <- (nrow(smaller_peak_overtop_after_jet %>% filter(overtopping == 1))/nrow(smaller_peak_overtop_after_jet))*100

# total < 2.5 in/hr

smaller_peak_overtop <- rainfall_overtopping_cs1 %>%
  filter(eventpeakintensity_inhr < 2.5)

smaller_peak_overtop_percent <- (nrow(smaller_peak_overtop %>% filter(overtopping == 1))/nrow(smaller_peak_overtop))*100


