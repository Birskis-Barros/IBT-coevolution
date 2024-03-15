setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function")

per_03 = read.csv("sp_pers_net1_03.csv", header=T)
per_03 = per_03[,-1]
per_03$rate = "Low"

y_3 = per_03$persistance
x_3 = per_03$degree

model_3 <- try(nls(y_3 ~ (a*x)/(b + x_3),start = list(a=0.75,b=5)))

a_3 = summary(model_3)$coefficients[2, 1] 
b_3 = summary(model_3)$coefficients[1, 1]

# Define the formula
formula <- y ~ (a * x) / (b + x)

# Plot the data points and add the smoothed curve
p = ggplot(per_03, aes(x = degree, y = persistance)) +
  scale_color_brewer(palette="Dark2") +
  geom_point(color="darkseagreen4") +
  theme_classic() +
  geom_smooth(method = "nls", formula = formula, 
              method.args = list(start = c(a = a_3, b = b_3)), 
              se = FALSE, color = "darkseagreen4") +
  ylim(0,1) +
  theme_classic() +
  xlab("Species Degree") +
  ylab("Species persistence on island") +
  labs(color = "Extinction Rate") + 
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12)) 

per_06 = read.csv("sp_pers_net1_06.csv", header=T)
per_06 = per_06[,-1]
per_06$rate = "Medium"

y_6 = per_06$persistance
x_6 = per_06$degree

model_6 <- try(nls(y_6 ~ (a*x_6)/(b + x_6),start = list(a=0.75,b=5)))

a_6 = summary(model_6)$coefficients[2, 1] 
b_6 = summary(model_6)$coefficients[1, 1]

q = p +
  geom_point(data= per_06, aes(x=degree, y=persistance), color="deeppink4") +
  geom_smooth(data = per_06, method = "nls", formula = formula, 
              method.args = list(start = c(a = a_6, b = b_6)), 
              se = FALSE, color = "deeppink4")
  ylim(0,1) +
  theme_classic() +
  xlab("Species Degree") +
  ylab("Species persistence on island") +
  labs(color = "Extinction Rate") + 
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12)) 


per_09 = read.csv("sp_pers_net1_09.csv", header=T)
per_09 = per_09[,-1]
per_09$rate = "High"

y_9 = per_09$persistance
x_9 = per_09$degree

model_9 <- try(nls(y_9 ~ (a*x_9)/(b + x_9),start = list(a=0.75,b=5)))

a_9 = summary(model_9)$coefficients[2, 1] 
b_9 = summary(model_9)$coefficients[1, 1]

m = q +
  geom_point(data= per_09, aes(x=degree, y=persistance), color="darkorange") +
  geom_smooth(data = per_09, method = "nls", formula = formula, 
              method.args = list(start = c(a = a_9, b = b_9)), 
              se = FALSE, color = "darkorange")
ylim(0,1) +
  theme_classic() +
  xlab("Species Degree") +
  ylab("Species persistence on island") +
  labs(color = "Extinction Rate") + 
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12)) 

ggsave("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/sp_pers_extrates_fitmodel.pdf")


# ______  ORRRRRR ___________________ 

per_all = rbind(per_03, per_06, per_09)
per_all$rate <- factor(per_all$rate, levels = c("Low", "Medium", "High"))


ggplot(per_all, aes(x=degree, y=persistance, group=rate, color=rate)) +
  geom_point() + 
  geom_smooth(se = FALSE) +
  ylim(0,1) +
  theme_classic() +
  xlab("Species Degree") +
  ylab("Species persistence on island") +
  # scale_color_manual(values = c("1" = "indianred4", 
  #  "2" = "olivedrab4", 
  # "3" = "steelblue3")) +
  scale_color_brewer(palette="Dark2", ) +
  labs(color = "Extinction Rate") + 
  #labs(color="Network") +
  #theme(legend.position = "none") +
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12)) 

#ggsave("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/sp_pers_extrates.pdf")
