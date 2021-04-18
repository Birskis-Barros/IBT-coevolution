#### Creating a null matrix with the same structure (number of columns, rows and total interactions) as other

function nullweb(A)

    nullA = copy(A);
    nullA[nullA .==1] .= 0
    ncol = size(A)[2]
    nrow = size(A)[1]

    for j = 1:ncol
        for i = 1:nrow
            if A[i,j] == 1
                a=2
                while a > 1
                    sample_col = rand(collect(1:ncol))
                    sample_row = rand(collect(1:nrow))
                    if nullA[sample_row, sample_col] == 1
                        a = 2
                    else nullA[sample_row, sample_col] == 0
                        nullA[sample_row, sample_col] = 1
                        a = 1
                    end
                end
            end
        end
    end

    #Checking to see if there is any zero column
    numzeros = findall(iszero, sum(nullA, dims=1));

    for i = 1:size(numzeros)[1]
        loc_moreth2 = findall(x->x>1, sum(nullA, dims=1));
        moreth2 = map(u->u[2], loc_moreth2)
        c_oldpos = rand(moreth2, 1);
        #find empties

        #choose new row position
        r_newpos = rand(1:nrow);;

        #row old position
        r_oldpos = rand(findall(!iszero,nullA[:,c_oldpos]))[1]

        #turn off old link; turn on new link
        nullA[r_oldpos, c_oldpos[1]] = 0;
        nullA[r_newpos, numzeros[i][2]] = 1;
    end

    return nullA
end
