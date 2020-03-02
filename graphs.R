ind_effects

help("rbind")

teste = rbind(ind_effects[,1],ind_effects[,2])
 a= ind_effects[,1]
b = ind_effects[,2] 

d1 = NA

SALVANDO = d1
d1$a = as.numeric(d1$a)
d1=SALVANDO

d3 = data.frame(a = c(ind_effects9[,1], ind_effects9[,2], ind_effects9[,3],
                      ind_effects9[,4], ind_effects9[,5]))
d3$strength = c("0.9")
d3$structure = c(rep("pool",59), rep("0.8",59), rep("0.6",59), rep("0.4",59), rep("0.2",59))

d1$network = rep(seq(1,59),5)

d1 = rbind(d1,d2,d3)

ggplot(data=d1, aes(x=structure, y=a, color = strength)) +
         geom_point(alpha = 0.3, size=5)+
  theme_classic() + 
  theme(axis.text = element_text(vjust=1,size=10))+
  labs(x = "Structure/Distance", y="Contribution to trait evolution") +
        


total = data.frame(NA)
total[5,1] = mean(d1$a[which(d1$structure=="0.2")])
total[,2] = c("pool","0.8", "0.6", "0.4", "0.2")
colnames(total) = c("ind","type","dir")
total$dir = 1
total[,-4]


ggplot() + 
  geom_bar(data=total, aes( x=type, y=dir), stat="identity", width=0.4, fill="gray") + 
  geom_bar(data=total, aes(x=type, y=ind), stat="identity", width=0.4, fill="turquoise4") + 
  geom_point(data=d1, aes(y=a, x=structure),  size=3, colour="white", fill="black") + 
  scale_fill_manual(values="deeppink4") +
  theme_minimal() + 
  # xlab("Pollination")+
  ylab("Contribution to trait evolution")  +
  theme(axis.text = element_text(size = 12)) +
  scale_y_continuous(breaks = seq(0, 1.0, by = 0.2), 
                     limits = c(0, 1.0) )

