### using "half_sat.csv" in results

using RCall

R"""
  setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/")
  library("ggplot2")

  result = read.csv("half_sat.csv", header = T)
  result$net = as.character(result$net)

  ggplot(result, aes(x=ext, y=half_sat, group=net, color=net)) +
    geom_line(linetype = "dashed", size = 1, show.legend = FALSE) +
    geom_point(size=3, show.legend = FALSE) +
    ylab("Half Saturation Point") +
    xlab("Type of Extinction") +
    theme_classic()

    ggsave("half_sat_ext_type.pdf", file=""/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphswith_profit_function/")


"""
