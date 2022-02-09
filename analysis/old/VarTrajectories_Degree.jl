### Calculating the variance of the trajectories of each sp in different networks and the degree of the sp#####

for u=1:20 #number of networks in the analysis

      m=u
      filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
      adj_network = CSV.read(filename, header=false);
      adj_network = convert(Array,adj_network);
      adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix


      #To calculate the degree of each sp

      Splants = size(adj_network)[1]; #number of plants
      Spollinator = size(adj_network)[2]; #number of pollinator
      n_S = Splants + Spollinator;

      M = repeat([mi],outer= n_S);
      PHI = repeat([phi], outer= n_S);

      ##Creating a square matrix
      zero_plant = zeros(Splants, Splants);
      zero_pollinator = zeros(Spollinator, Spollinator);
      a = hcat(zero_plant, adj_network);
      b = hcat(adj_network', zero_pollinator);
      square_adj_network = vcat(a,b); #square matrix = plants + pollinator

      a = sum(square_adj_network, dims=2)

      ## Filtering the sp I want
      R"""

      new20 = matrix(NA, ncol=2, nrow=$(n_S))
      new20 = as.data.frame(new20)
      new20[,2] = a

      new20$type = c(rep("plant",$Splants), rep("pol",$Spollinator))

      """

      z_result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_size, col_rate, events); #plants and then animals

      trajlist = Array{Array{Float64}}(undef,0) # this array will save the trajectories

      splist = Array{Int64}(undef,0) #this array will save the species correspondent to each trajectory

      timelist = Array{Int64}(undef,0) # this array will save in what event does that trajectory starts (colonization event)

      diff_matrix = copy(z_result);

            for u=1:size(z_result)[1]
                  sp = diff_matrix[u,:]
                  sp[1] = 0.0

                  traj = copy(sp)
                  traj[traj.!=0] .= 1

                  #diff(Int64.(traj .> 0)) #finding when it colonizes (=1) and when it gets extinct (-1)

                  ev_col = findall(x->x==1,diff(Int64.(traj .> 0))) .+ 1  #events of colonization
                  ev_ext = findall(x->x==-1,diff(Int64.(traj .> 0))) #events of extinction

                  if size(ev_col)[1] > size(ev_ext)[1]
                        ev_col = ev_col[1:size(ev_ext)[1]]
                  else size(ev_col)[1] < size(ev_ext)[1]
                        ev_ext = ev_ext[1:size(ev_col)[1]]
                  end

                  for i=1:size(ev_ext)[1]
                        coe_traj = sp[ev_col[i]:ev_ext[i]]
                        push!(trajlist,coe_traj)
                        push!(splist,u)
                        push!(timelist,ev_col[i])
                  end
            end

      for i=1:n_S

            trajlist[findall(x->x==i,splist)] ## searching the trajectories correspondence to species 4
            tam = size(trajlist[findall(x->x==i,splist)])[1] #how many trajectories

            #Graph with the last value of each trajectory and initial value (the same as z of species in the mainland)

            trying = zeros(tam*2, 2);
            trying[[1:1:tam;],1] = last.(trajlist[findall(x->x==i,splist)]) ; #final values
            trying[[1:1:tam;],2] .= 2;

            trying[[(tam+1):1:(2*tam);],1] .= z_result[i,1]; #initial values
            trying[[(tam+1):1:(2*tam);],2] .= 1;

            R"""

            trying = as.data.frame($(Array(trying)))

            final_traits = trying[which(trying$V2==2),]
            initial_trait = trying[which(trying$V2==1),]

            new20[$i,1] = var(final_traits[,1])

            """
      end

            a = as.data.frame($(Array(a)))
            new202[,2] = a

            new202$type = c(rep("plant",$Splants), rep("pol",$Spollinator))

            total = rbind(total,new20)

            """

      end

end

####################

#Doing the graph

R"""

total$V1[is.na(total$V1)] <- 0


ggplot(total, aes(x=V2, y=V1, colour=type))+
geom_point(alpha=0.2) +
scale_color_manual(values=c("#5BB300", "#CF78FF"), labels = c("Plants", "Pollinators")) +
theme_classic() +
xlab("Sp Degree") +
ylab("Variance Trajectories") +
labs(color="Group") +
theme(axis.text=element_text(size=12),
               axis.title=element_text(size=14))



             g_pol = ggplot(pol, aes(x=V2, y=V1))+
               geom_point(color="#CF78FF") +
               #scale_color_manual(values=c("#5BB300", "#CF78FF"), labels = c("Plants", "Pollinators")) +
               theme_classic() +
               ylim(0.0,0.005) +
               xlab("Sp Degree") +
               ylab("Variance Final Trait Values") +
               scale_x_continuous(breaks = c(seq(from=1, to=6, by=1))) +
               #labs(color="Group") +
               theme(axis.text=element_text(size=12),
                              axis.title=element_text(size=14))


                        g_pla =     ggplot(plant, aes(x=V2, y=V1))+
                              geom_point(color="#5BB300") +
                              #scale_color_manual(values=c("#5BB300", "#CF78FF"), labels = c("Plants", "Pollinators")) +
                              theme_classic() +
                              ylim(0.0,0.005) +
                              xlab("Sp Degree") +
                              ylab("Variance Final Trait Values") +
                              scale_x_continuous(breaks = c(seq(from=1, to=18, by=1))) +
                              #labs(color="Group") +
                              theme(axis.text=element_text(size=12),
                                             axis.title=element_text(size=14))

 ggsave("degree_varTrajectories.pdf", path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/gillespie_algorithm/new20/trajectories/",


"""

total = rbind(new1, new2, new3, new4, new5, new6, new7, new8, new9, new10,
      new11, new12, new13, new14, new15, new16, new17, new18, new19, new20)
pol = total1[which(total$type == "pol"),]


figure = ggarrange(g_pol,g_pla,
      labels = c("A", "B"),
   ncol=2, nrow=1)

 ggsave("degree_varTrajectories.pdf.pdf", figure, path="/Users/irinabarros/Desktop", width=11, height = 6.5)
