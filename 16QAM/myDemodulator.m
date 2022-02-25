function [decisions_gray,decisions_bin] = myDemodulator(receivedbin,constellation,ninputs,gre)
    decisions=zeros(ninputs,1); %I initialized decisions with zeros corresponding to all n symbols.
    decisions_bin = zeros(1,ninputs);
    for n=1:ninputs 
        
        distancesbin = abs(receivedbin(n)-constellation); %calculating absolute distance of every signal point from each point of constellation.
        [min_dist_bin,decisions_bin(n)] = min(distancesbin(:)); %The minimum distance constellation point is the signal.
    end
   
  
    decisions_gray=gre(decisions_bin); %We map the decoded signal back to gray code input to compare error for gray.
    %The decisions_bin are index values while they correspond to some
    %decisions_gray value.
    decisions_bin=decisions_bin-1; %To make it from 0 to 15.