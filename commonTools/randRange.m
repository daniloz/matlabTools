% Generate values from the uniform distribution on the interval [rmin, rmax]
function r = randRange(rmin,rmax, M,N)
    r = rmin + (rmax-rmin)*rand(M,N);
end
