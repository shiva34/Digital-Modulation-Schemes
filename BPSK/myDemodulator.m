function decisions = myDemodulator (nsymbols, constellation, received)
    decisions=zeros(nsymbols,1); %We initialize decisions with zeros corresponding to all n symbols.
    for n=1:nsymbols %Symbol for loop to compute distance which is used to stimulate recieved signal being 1 or -1.
        distances = abs(received(n)-constellation); %It stores a vector of absolute distance 
                                                        %from each of the constellation points 1 and -1.
        [min_dist,decisions(n)] = min(distances); %We store the minimum of those distances with memory location 
                                                   %(which will be 1 if the point is closer to the constellation point1
                                                   %and 2 if the point is closer to the constellation point -1.)
    end
end