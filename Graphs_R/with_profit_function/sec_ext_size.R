## Graph Number of Cascades x Extinction Cascade Sizes 
library("ggplot2")
library("reshape")

### Random Extinctions

setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/Size_sec_ext/Relative_richness/Random/E_03/")

net = read.csv("sec_1_R_03.csv", header=T)
net = net[,-1]

net_all = read.csv("sec_2_R_03.csv", header=T)
net_all = net_all[,-1]

all_net = rbind(net_all, net)

for(i in 3:54){
  
   filename = paste("sec_", i, "_R_03.csv", sep="")
    net = read.csv(filename, header=T)
    net = net[,-1]
    all_net = rbind(all_net, net)

}

df = melt(all_net)
df = df[df$value != 0, ]

df$value = round(df$value, digits=2)

# Count the frequency of each unique value
data_counts <- table(df$value)

# Convert the frequency table to a dataframe
freq_df <- data.frame(value = as.numeric(names(data_counts)), frequency = as.numeric(data_counts))
#freq_df$type = "Random"
freq_df_03 = freq_df
freq_df_03$rate = 0.3

freq_comb = rbind(freq_df_03, freq_df_06, freq_df_09)
freq_comb$rate = as.character(freq_comb$rate)

# Order the data frame by frequency in descending order
freq_comb <- freq_comb[order(-freq_comb$frequency), ]



quartz()
ggplot(freq_comb, aes(x = value, y = log(frequency), color=rate)) +
  geom_point() +
 scale_color_manual(values = c("blue", "deeppink2", "green"), label=c("Low", "Medium", "High")) + 
  labs(x = "Relative extinction cascade size", y = "Log number of cascades") +
  labs(color = "Extinction Rates", size=20) +
  xlim(0,1) +
  #lim(0,15) +
  ggtitle("Random") +
  theme_classic() +
  theme(axis.text = element_text(size = 14),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20)) 


freq_df_03_R = freq_df_03
freq_df_03_R$type = "Random"

freq_df_06_R = freq_df_06
freq_df_06_R$type = "Random"

freq_df_09_R = freq_df_09
freq_df_09_R$type = "Random"

# Trait-based

setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/Size_sec_ext/Relative_richness/Non-Random/E_09/")

net = read.csv("sec_1_NR_09.csv", header=T)
net = net[,-1]

net_all = read.csv("sec_2_NR_09.csv", header=T)
net_all = net_all[,-1]

all_net = rbind(net_all, net)

for(i in 3:54){
  
  filename = paste("sec_", i, "_NR_09.csv", sep="")
  net = read.csv(filename, header=T)
  net = net[,-1]
  all_net = rbind(all_net, net)
  
}

df = melt(all_net)
df = df[df$value != 0, ]

df$value = round(df$value, digits=2)

# Count the frequency of each unique value
data_counts <- table(df$value)

# Convert the frequency table to a dataframe
freq_df <- data.frame(value = as.numeric(names(data_counts)), frequency = as.numeric(data_counts))
#freq_df$type = "Random"
freq_df_09 = freq_df
freq_df_09$rate = 0.9


freq_comb = rbind(freq_df_03, freq_df_06, freq_df_09)
freq_comb$rate = as.character(freq_comb$rate)

# Order the data frame by frequency in descending order
freq_comb <- freq_comb[order(-freq_comb$frequency), ]


quartz()
ggplot(freq_comb, aes(x = value, y = log(frequency), color=rate)) +
  geom_point() +
  scale_color_manual(values = c("blue", "deeppink2", "green"), label=c("Low", "Medium", "High")) + 
  labs(x = "Relative extinction cascade size", y = "Log number of cascades") +
  labs(color = "Extinction Rates", size=20) +
  xlim(0,1) +
  #lim(0,15) +
  ggtitle("Trait-based") +
  theme_classic() +
  theme(axis.text = element_text(size = 14),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20)) 

freq_df_03_TB = freq_df_03
freq_df_03_TB$type = "Trait-based"

freq_df_06_TB = freq_df_06
freq_df_06_TB$type = "Trait-based"

freq_df_09_TB = freq_df_09
freq_df_09_TB$type = "Trait-based"

#### For each rate

freq_03 = rbind(freq_df_03_TB, freq_df_03_R)
freq_06 = rbind(freq_df_06_TB, freq_df_06_R)
freq_09 = rbind(freq_df_09_TB, freq_df_09_R)


freq_03 <- freq_03[order(-freq_03$frequency), ]
freq_06 <- freq_06[order(-freq_06$frequency), ]
freq_09 <- freq_09[order(-freq_09$frequency), ]

ggplot(freq_09, aes(x = value, y = log(frequency), color=type)) +
  geom_point() +
  scale_color_manual(values = c("orchid", "blue")) + 
  labs(x = "Relative extinction cascade size", y = "Log number of cascades") +
  labs(color = "Extinction Rates", size=20) +
  #xlim(0,1) +
  #lim(0,15) +
  ggtitle("Extinction Rate = 0.9") +
  theme_classic() +
  theme(axis.text = element_text(size = 14),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20)) 

