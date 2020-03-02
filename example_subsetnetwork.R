### Example on how to chose a subset network from the pool: 


 a = sample(c(0,1), 12, replace=TRUE)
 A = matrix(a,4,3)
 A[2,1]=0
 A[4,2]=0

A= network

B = as.integer(0.9*dim(A)[1])

C = sort(sample(1:dim(A)[1], B))

network = A[C,C]

teste <- A[ , which(colSums(A) > 0)]
teste <- A[which(colSums(A) > 0), ]

