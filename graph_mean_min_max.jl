include ("$(homedir())/Dropbox/PhD/IBT_coevolution/Codes/IBT-coevolution/IBT_coevolution.jl")

## Chamando o output do codigo IBT_coevolution, que eh "ind_effects"
#a partir dai, vou rodar pra cada rede um grafico com a media, max e min das "reps" simulacoes que eu rodei.

medias = zeros(1, length(col));
minim = zeros(1, length(col));
maxim = zeros(1, length(col));

for j=1:145
  for i=1:9
    medias[1,i] = mean(ind_effects[:,j,:][:,i])
    minim[1,i] = minimum(ind_effects[:,j,:][:,i])
    maxim[1,i] = maximum(ind_effects[:,j,:][:,i])
  end

R"""
medias = as.data.frame(($(Array(medias2))))
min = as.data.frame(($(Array(minim2))))
max = as.data.frame(($(Array(maxim2))))

result = cbind(t(medias),t(min))
result = cbind(result, t(max))
result = as.data.frame(result)
colnames(result) = c("mean", "min", "max")
result$distance = c("pool", "90", "80", "70", "60", "50", "40", "30", "20")

ggsave(file=sprintf("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/mean_indeffects_networks/network_%s.pdf", ($(Int(j)))),
       width = 6, height = 8,
       plot = last_plot())

ggplot(result) +
  geom_line(aes(factor(distance),mean), group=1) +
  geom_line(aes(x=factor(distance), y = max, group=1), color = "skyblue") +
  geom_line(aes(x=factor(distance), y = min, group=1), color = "skyblue") +
  #geom_ribbon(aes(x=factor(distance),ymin=min,ymax=max),color="skyblue", alpha=0.3)+
  scale_x_discrete(limits = c("pool", "90", "80", "70", "60", "50", "40", "30", "20")) +
  xlab("Subset network")  +
  theme_classic()

"""
end
