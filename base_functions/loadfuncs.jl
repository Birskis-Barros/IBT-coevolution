using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall
using DataFrames
using JLD2
using SpecialFunctions

# R"""
# library("ggplot2")
# library("ggpubr")
# library("drc")
# library(reshape2)
# library("bipartite")
# library(tidyr)
# library(ggside)
# """

######### LOADING FUNCTIONS ################
if homedir() == "/Users/irinabarros"    #for downward compatibility ;)
    #localpath::String = "$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/";
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/coev_island.jl")
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/coevolution_mainland.jl")
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/colonization.jl")
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/random_ext.jl")
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/profitability_ext.jl")
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/gillespie_algorithm.jl")
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/initial_island.jl")
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/potential_colonizers.jl")
    include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/mean_positives_matrix.jl")
elseif homedir() == "/home/irinabarros"
    #localpath::String = "$(homedir())/IBT_coev/IBT-Coevolution/base_functions/";
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/casc_ext.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/coev_island.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/coevolution_mainland.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/colonization.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/random_ext.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/profitability_ext.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/gillespie_algorithm.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/initial_island.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/potential_colonizers.jl")
    include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/mean_positives_matrix.jl")
end;

#load all necessary functions
#include(localpath*"loadfuncs.jl");

#include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/casc_ext.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/coev_island.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/coevolution_mainland.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/colonization.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/random_ext.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/profitability_ext.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/gillespie_algorithm.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/initial_island.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/potential_colonizers.jl")
# include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/mean_positives_matrix.jl")

###YOG
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/casc_ext.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/coev_island.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/coevolution_mainland.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/colonization.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/random_ext.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/profitability_ext.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/gillespie_algorithm.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/initial_island.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/potential_colonizers.jl")
# include("/home/irinabarros/IBT_coev/IBT-coevolution/base_functions/mean_positives_matrix.jl")
