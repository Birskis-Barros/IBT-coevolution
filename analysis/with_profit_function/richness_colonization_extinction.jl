#### Exploring Island' richness

loadfunc = include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/loadfuncs.jl") #start everytime with this

R"""
     library(reshape2)
     library(ggplot2)
     library(tidyr)
     library("ggpubr")
     library(ggside)
"""

phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 5000; #total number of events
n_start_plants = 1 #initial number of plants in the island (it will be the same number of polinators)
ext_rate = 0.7; # extinction rate (related to the size of the island)
col_rate = 1; ##colonization rate
coev_rate = 1 #coevolutionary rate

###For the PrExt_Error function
##Calculating Exp_Prof
a_fit = 1
b_fit = 1
g_fit = 100

##Calculating Pr of Extinction
#Gradual
threshold = 96.5
StDevProfit = 38.5

## Number of network to check
numb_net = 12

richness = zeros(numb_net,events);

  for l=1:numb_net #from network 1 to numb_net

      m = l
      if homedir() == "/Users/irinabarros"
          filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
      elseif homedir() == "/home/irinabarros"
          filename = string("$(homedir())/IBT_coev/Data_Pollination/pollination/network_",m,".csv");
      end

      adj_network = CSV.read(filename,header=false,DataFrame);
      adj_network = Array(adj_network);
      adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
      z_result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_rate, col_rate, coev_rate, events)[1];

      z_result[z_result.>0] .= 1 ;# focusing on the richness

      freq_sp = sum(z_result, dims=1);
      richness[l,:] = freq_sp ./ (freq_sp[1,1])

   end

#namespace = "/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/richness/richness_c07.jld"
#@save namespace richness_c07


R"""
     numb_net = $numb_net
     events = $events
     richness = as.data.frame($(Array(richness)))
     richness = melt(richness)
     richness = richness[-c(1:numb_net),] #removing the data related to the richness in the mainland
     richness$network = rep(1:numb_net,(events-1))
     richness$event = rep(1:(events-1), each=numb_net)

    richness$network = as.character(richness$network)

    ## in case I want to filter networks
    my_nets = richness[which(richness$network==11),]

     net12 = ggplot(my_nets, aes(x=events, y=value, color=network)) +
     geom_line() +
     ylim(0,1) +
     theme_classic() +
     xlab("Events") +
     ylab("Richness") +
     #labs(color="Network") +
     theme(axis.text=element_text(size=20),
                    axis.title=element_text(size=20)) +
    theme(legend.title = element_text(size = 18),
                    legend.text = element_text(size = 14)) +
                    theme(legend.title = element_blank())

    ggsave("richness_island2.pdf", path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/")

    """

    ### For combining all the graphs together - for different graphs for distinct values of colonization and extinction

    #c01_g1_3, c07_g1_3,c1_g1_3 #graphs with 3 networks
    #c01_g1_5, c07_g1_5, c1_g1_5 #graphs with 5 networks
    #c01_g1_10, c07_g1_10, c1_g1_10 #graphs with 10 networks

     figure <- ggarrange(net1, net2, net3, net4, net5, net6,
                         net7, net8, net9, net10, net11, net12,
               ncol = 3, nrow = 4)

      ggsave("richness_net1_12.pdf", figure, path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/"),
      width=30, height = 10)


      ggplot(net12, aes(x=events, y=value, color=network)) +
      geom_line() +
      ylim(0,1) +
      theme_classic() +
      xlab("Events") +
      ylab("Richness") +
      #labs(color="Network") +
      theme(axis.text=element_text(size=20),
                     axis.title=element_text(size=20)) +
      theme(legend.title = element_text(size = 18),
                     legend.text = element_text(size = 14)) +
                     theme(legend.title = element_blank())  +
    geom_ysidedensity(aes(x=after_stat(density)), position="stack")
