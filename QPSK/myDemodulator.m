function [ decisions, decisions_gray ] = myDemodulator (nsymbols, received, constellation)
    decisions=zeros(nsymbols,1); %We initialize decisions with zeros corresponding to all n symbols for fast execution.
    for n=1:nsymbols         
        distances = abs(received(n)-constellation);%Absolute distance from each constellation point.
        [min_dist,decisions(n)] = min(distances); %The minimum of those is choosen for that recieved point.
    
    end    
    gre=[0 1 3 2]; %This is used to map between non - gray and gray constellation points.
    decisions_gray=gre(decisions);%Maps back non gray to gray
    decisions=decisions-1;%To get it between 0 and 3.
end