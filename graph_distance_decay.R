
ind_effects = as.data.frame(ind_effects)
ind_effects$network = 1:59
colnames(ind_effects) = c("pool", "oit", "sess", "qua", "vint")

a = data.frame(rep(1:59,5))
  
a$values =  NA
a$distance = NA
a[1:59,2] = ind_effects[,1]
a[1:59,3] = "pool"
a[60:118,2] = ind_effects[,2]  
a[60:118,3] = "80"
a[119:177,2] = ind_effects[,3]                
a[119:177,3] = "60"
a[178:236,2] = ind_effects[,4] 
a[178:236,3] = "40"
a[237:295,2] = ind_effects[,5] 
a[237:295,3] = "20"

colnames(a) = c("network", "value", "distance")
a$distance = factor(a$distance, levels = c("pool", "80", "60", "40", "20"))

ggplot(a, aes(x=factor(distance), y=value, group=factor(network), color=factor(network)))+
  geom_line() +
  theme_classic()

a = result
