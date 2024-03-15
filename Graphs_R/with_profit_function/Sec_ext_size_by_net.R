library(ggplot2)
library(ggpubr)

#Extinction rate = 0.3

for(i in 1:54){
    
    setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/Size_sec_ext/Relative_richness/Random/E_03/")
    
    net = paste("sec_", i, "_R_03.csv", sep="")
    net_R = read.csv(net, header=T)
    net_R = net_R[,-1]
    df_R = melt(net_R)
    df_R = df_R[df_R$value != 0, ]
    df_R$value = round(df_R$value, digits=4)
    # Count the frequency of each unique value
    data_counts <- table(df_R$value)
    freq_R <- data.frame(value = as.numeric(names(data_counts)), frequency = as.numeric(data_counts))
    if (any(is.infinite(freq_R$value))) {
      # Remove rows with infinite values in the 'value' column
      freq_R <- freq_R[-which(is.infinite(freq_R$value)), ]
    }
    freq_R$value = freq_R$value/max(freq_R$value)
    freq_R$type = "Random"
    
    
    setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/Size_sec_ext/Relative_richness/Non-random/E_03/")
    
    net = paste("sec_", i, "_NR_03.csv", sep="")
    net_NR = read.csv(net, header=T)
    net_NR = net_NR[,-1]
    df_NR = melt(net_NR)
    df_NR = df_NR[df_NR$value != 0, ]
    df_NR$value = round(df_NR$value, digits=4)
    # Count the frequency of each unique value
    data_counts <- table(df_NR$value)
    freq_NR <- data.frame(value = as.numeric(names(data_counts)), frequency = as.numeric(data_counts))
    freq_NR$type = "Trait-based"
    if (any(is.infinite(freq_NR$value))) {
      # Remove rows with infinite values in the 'value' column
      freq_NR <- freq_NR[-which(is.infinite(freq_NR$value)), ]
    }
    freq_NR$value = freq_NR$value/max(freq_NR$value)
    
    net_L = rbind(freq_R, freq_NR)
    
    L = ggplot(net_L, aes(x = value, y = log(frequency), color=type)) +
      geom_point() +
      scale_color_manual(values = c("orchid", "blue")) + 
      labs(x = "Relative extinction cascade size", y = "Log number of cascades") +
      labs(color = "Extinction Rates", size=20) +
      #xlim(0,0.25) +
      ylim(0,7.5) +
      ggtitle("Extinction Rate = Low") +
      theme_classic() +
      theme(axis.text = element_text(size = 14),
            legend.title = element_text(size = 16),
            legend.text = element_text(size = 14),
            axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
            plot.title = element_text(size = 20)) 
    
    # Extinction Rate = Medium 
    
    setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/Size_sec_ext/Relative_richness/Random/E_06/")
    
    net = paste("sec_", i, "_R_06.csv", sep="")
    net_R = read.csv(net, header=T)
    net_R = net_R[,-1]
    df_R = melt(net_R)
    df_R = df_R[df_R$value != 0, ]
    df_R$value = round(df_R$value, digits=4)
    # Count the frequency of each unique value
    data_counts <- table(df_R$value)
    freq_R <- data.frame(value = as.numeric(names(data_counts)), frequency = as.numeric(data_counts))
    freq_R$type = "Random"
    if (any(is.infinite(freq_R$value))) {
      # Remove rows with infinite values in the 'value' column
      freq_R <- freq_R[-which(is.infinite(freq_R$value)), ]
    }
    freq_R$value = freq_R$value/max(freq_R$value)
    
    
    setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/Size_sec_ext/Relative_richness/Non-random/E_06/")
    
    net = paste("sec_", i, "_NR_06.csv", sep="")
    net_NR = read.csv(net, header=T)
    net_NR = net_NR[,-1]
    df_NR = melt(net_NR)
    df_NR = df_NR[df_NR$value != 0, ]
    df_NR$value = round(df_NR$value, digits=4)
    # Count the frequency of each unique value
    data_counts <- table(df_NR$value)
    freq_NR <- data.frame(value = as.numeric(names(data_counts)), frequency = as.numeric(data_counts))
    freq_NR$type = "Trait-based"
    if (any(is.infinite(freq_NR$value))) {
      # Remove rows with infinite values in the 'value' column
      freq_NR <- freq_NR[-which(is.infinite(freq_NR$value)), ]
    }
    freq_NR$value = freq_NR$value/max(freq_NR$value)
    
    net_M = rbind(freq_R, freq_NR)
    
    M = ggplot(net_M, aes(x = value, y = log(frequency), color=type)) +
      geom_point() +
      scale_color_manual(values = c("orchid", "blue")) + 
      labs(x = "Relative extinction cascade size", y = "Log number of cascades") +
      labs(color = "Extinction Rates", size=20) +
      #xlim(0,0.25) +
      ylim(0,7.5) +
      ggtitle("Extinction Rate = Medium") +
      theme_classic() +
      theme(axis.text = element_text(size = 14),
            legend.title = element_text(size = 16),
            legend.text = element_text(size = 14),
            axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
            plot.title = element_text(size = 20)) 
    
    # Extinction Rate = High
    
    setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/Size_sec_ext/Relative_richness/Random/E_09/")
    
    net = paste("sec_", i, "_R_09.csv", sep="")
    net_R = read.csv(net, header=T)
    net_R = net_R[,-1]
    df_R = melt(net_R)
    df_R = df_R[df_R$value != 0, ]
    df_R$value = round(df_R$value, digits=4)
    # Count the frequency of each unique value
    data_counts <- table(df_R$value)
    freq_R <- data.frame(value = as.numeric(names(data_counts)), frequency = as.numeric(data_counts))
    freq_R$type = "Random"
    if (any(is.infinite(freq_R$value))) {
      # Remove rows with infinite values in the 'value' column
      freq_R <- freq_R[-which(is.infinite(freq_R$value)), ]
    }
    freq_R$value = freq_R$value/max(freq_R$value)
    
    setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/Size_sec_ext/Relative_richness/Non-random/E_09/")
    
    net = paste("sec_", i, "_NR_09.csv", sep="")
    net_NR = read.csv(net, header=T)
    net_NR = net_NR[,-1]
    df_NR = melt(net_NR)
    df_NR = df_NR[df_NR$value != 0, ]
    df_NR$value = round(df_NR$value, digits=4)
    # Count the frequency of each unique value
    data_counts <- table(df_NR$value)
    freq_NR <- data.frame(value = as.numeric(names(data_counts)), frequency = as.numeric(data_counts))
    freq_NR$type = "Trait-based"
    if (any(is.infinite(freq_NR$value))) {
      # Remove rows with infinite values in the 'value' column
      freq_NR <- freq_NR[-which(is.infinite(freq_NR$value)), ]
    }
    freq_NR$value = freq_NR$value/max(freq_NR$value)
    
    net_H = rbind(freq_R, freq_NR)
    
    H = ggplot(net_H, aes(x = value, y = log(frequency), color=type)) +
      geom_point() +
      scale_color_manual(values = c("orchid", "blue")) + 
      labs(x = "Relative extinction cascade size", y = "Log number of cascades") +
      labs(color = "Extinction Rates", size=20) +
      #xlim(0,0.25) +
      ylim(0,7.5) +
      ggtitle("Extinction Rate = High") +
      theme_classic() +
      theme(axis.text = element_text(size = 14),
            legend.title = element_text(size = 16),
            legend.text = element_text(size = 14),
            axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
            plot.title = element_text(size = 20)) 
    
    fig = ggarrange(L, M, H, ncol=3, nrow=1)
    filename = paste("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/Size_sec_extinctions/By_network/net_", i, ".pdf", sep="")
    ggsave(fig, file=filename, width = 16, height = 10 )
}
