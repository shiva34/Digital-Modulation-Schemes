%--%
function derep = myDerepeater(bits,reps,symbols)
    derep = zeros(symbols,1);
    j = 0;
    %for loop with jump of no. of repeation
    for i=1:reps:length(bits)-reps+1
        j = j + 1;
        bit = bits(i:i-1+reps);
        %taking mode to get one bit out & putting in derep vector
        derep(j) = mode(bit);
    end
end