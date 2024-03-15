setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/HS_realized_degree/ext_06/")

###Code for the freq plot of the Delta Half-Saturation Point for Realizer or Potential Degree
#(change directory)

library("ggplot2")

#For Non-NRandom - combining results in one data.frame
NR_net_1_10 = read.csv("1_10_half_net_NR_06.csv", header=T)
NR_net_1_10 = NR_net_1_10[1:200,]

NR_net_11_20 = read.csv("11_20_half_net_NR_06.csv", header=T)
NR_net_11_20 = NR_net_11_20[201:400,]

NR_net_21_30 = read.csv("21_30_half_net_NR_06.csv", header=T)
NR_net_21_30 = NR_net_21_30[401:600,]

NR_net_31_40 = read.csv("31_40_half_net_NR_06.csv", header=T)
NR_net_31_40 = NR_net_31_40[601:800,]

NR_net_41_54 = read.csv("41_54_half_net_NR_06.csv", header=T)
NR_net_41_54 = NR_net_41_54[801:1080,]

NR_net = rbind(NR_net_1_10, NR_net_11_20, NR_net_21_30, NR_net_31_40, NR_net_41_54)

#For Random - combining results in one data.frame

R_net_1_10 = read.csv("1_10_half_net_R_06.csv", header=T)
R_net_1_10 = R_net_1_10[1:200,]

R_net_11_20 = read.csv("11_20_half_net_R_06.csv", header=T)
R_net_11_20 = R_net_11_20[201:400,]

R_net_21_30 = read.csv("21_30_half_net_R_06.csv", header=T)
R_net_21_30 = R_net_21_30[401:600,]

R_net_31_40 = read.csv("31_40_half_net_R_06.csv", header=T)
R_net_31_40 = R_net_31_40[601:800,]

R_net_41_54 = read.csv("41_54_half_net_R_06.csv", header=T)
R_net_41_54 = R_net_41_54[801:1080,]

R_net = rbind(R_net_1_10, R_net_11_20, R_net_21_30, R_net_31_40, R_net_41_54)

##Taking the mean/sd/quartile for each network 

#Non-Random
NR_result_potential = matrix(NA, ncol= 5, nrow=54)
NR_result_potential = as.data.frame(NR_result_potential)
colnames(NR_result_potential) = c("network", "mean", "sd", "qua_05", "qua_95")
NR_result_potential$network = 1:54
NR_result_potential$type_ext = "non_random"

for (i in 1:54) {
    a = NR_net[which(NR_net$network==i),]
    NR_result_potential$mean[i] <- mean(a$HS, na.rm=TRUE)
    NR_result_potential$sd[i] <- sd(a$HS, na.rm=TRUE)
    NR_result_potential$qua_05[i] <- quantile(a$HS, 0.05, na.rm=TRUE)
    NR_result_potential$qua_95[i] <- quantile(a$HS, 0.95, na.rm=TRUE)
}

#Random 
R_result_potential = matrix(NA, ncol= 5, nrow=54)
R_result_potential = as.data.frame(R_result_potential)
colnames(R_result_potential) = c("network", "mean", "sd", "qua_05", "qua_95")
R_result_potential$network = 1:54
R_result_potential$type_ext = "random"

for (i in 1:54) {
  a = R_net[which(R_net$network==i),]
  R_result_potential$mean[i] <- mean(a$HS, na.rm=TRUE)
  R_result_potential$sd[i] <- sd(a$HS, na.rm=TRUE)
  R_result_potential$qua_05[i] <- quantile(a$HS, 0.05, na.rm=TRUE)
  R_result_potential$qua_95[i] <- quantile(a$HS, 0.95, na.rm=TRUE)
}

#Calculating Delta HS for each network 
result_potential = NR_result_potential$mean - R_result_potential$mean
result_potential = as.data.frame(result_potential)

#Ploting freq of Delta values 
ggplot(result_potential, aes(x=result_potential)) +
  geom_histogram(fill = "darkgreen", color = "black", alpha = 0.7) +
  geom_vline(xintercept = 0, color = "gray", linetype = "dashed", size = 1) +
  xlim(-20,20) +
  ylim(0,50) +
  labs(title = "Extinction Rate = 0.6", x = expression(Delta * S[0]), y = "Frequency") +
  theme(axis.text = element_text(size = 12), 
        axis.title = element_text(size = 14),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 16)) +
  theme_classic()

ggsave("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/HS_realized_degree/06.pdf")

#Ploting boxplot of random x non-random combining all networks 
NR_net$type = "Non_random"
R_net$type = "Random"

all = rbind(NR_net, R_net)

## Perform t-test
#t_test_result <- t.test(all$HS ~ all$type, data = all)
#p_value <- t_test_result$p.value

ggplot(all, aes(x=type, y =HS, color=type)) +
  geom_boxplot() +
  ylim(0,5) +
  scale_color_manual(values = c("darkgreen", "deeppink4")) + 
  labs(title = "Extinction Rate = 0.6", x = "Type of Extinction", y = expression(S[0])) +
  theme_classic() +
  theme(axis.text = element_text(size = 12), 
        axis.title = element_text(size = 14),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 16)) + # Adjust the font size and style for plot title+
  guides(color = FALSE) 
  #annotate("text", x = 1.5, y = 4.5, label = paste("p-value:", round(p_value, 4)), size = 4)
  
ggsave("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/HS_realized_degree/boxplot_06.pdf")

  