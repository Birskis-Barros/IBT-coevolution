######### LOADING FUNCTIONS ################

using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall
using DataFrames
using JLD2
using SpecialFunctions

include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/casc_ext.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/coev_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/coevolution_mainland.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/colonization.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/random_ext.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/profitability_ext.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/gillespie_algorithm.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/initial_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/potential_colonizers.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/mean_positives_matrix.jl")

R"""
library("ggplot2")
library("ggpubr")
library("drc")
library(reshape2)
library("bipartite")
library(tidyr)
library(ggside)
"""
