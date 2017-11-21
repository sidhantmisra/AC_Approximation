using JuMP
using Ipopt
# using Plots
# gr()

n = 3
gamma = 0.1


minval = 100

for t23 = -gamma:0.01:gamma
    for t12 = -(1-abs(t23)):0.01:(1-abs(t23)), t13 = -(1-abs(t23)):0.01:(1-abs(t23))
        theta = eye(n)
        theta[2,3]=t23
        theta[1,3]=t13
        theta[1,2]=t12

        expval = zeros(2^n)
        for l = 0:2^n-1
            expval[l+1] = exp(sum(theta[i,j]*(2*digits(l,2,n)[i]-1)*(2*digits(l,2,n)[j]-1) for i=1:n for j=i+1:n))
        end
        z = sum(expval)

        varmat = eye(n)
        for i=1:n, j=i+1:n
            varmat[i,j] = (1/z)*sum( (2*digits(l,2,n)[i]-1)*(2*digits(l,2,n)[j]-1)*expval[l+1] for l=0:2^n-1 )
            varmat[j,i] = varmat[i,j]
        end

        smallest_eig = minimum(eigvals(varmat))

        minval = min(minval,smallest_eig)

    end
end

@show minval
@show tanh(gamma)
