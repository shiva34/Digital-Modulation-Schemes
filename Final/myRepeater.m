function rep_bits = myRepeater(bits,reps)
    rep_bits = [];
    new = zeros(reps,1);
    for i=1:length(bits)
        % Selects the Bit
        bit = bits(i);
        % Repeats the bits
        for j=1:reps
            new(j) = bit;
        end
        % Adds the bits
        rep_bits = [rep_bits new'];
    end
    rep_bits = rep_bits';
end