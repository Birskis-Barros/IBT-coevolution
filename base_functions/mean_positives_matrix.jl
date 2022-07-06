###To calculate the mean positives of a matrix 

function meanpositives(mat::Matrix)
    nc = size(mat,2)
    sums = zeros(nc)
    counts = zeros(nc)
    for c in 1:nc
        for r in 1:size(mat,1)
            v = mat[r,c]
            if v > 0
                sums[c] += v
                counts[c] += 1.0
            end
        end
    end
    Float64[(counts[i]>0 ? sums[i]/counts[i] : 0.0) for i in 1:nc]
end