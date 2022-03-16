function deleav = Deinterleaver(bits,parts)
    deleav = [];
    size = length(bits)/parts;
    for i=1:parts
        % Repeats the bits
        for j=1:size
            deleav = [deleav bits((j-1)*parts + i)];
        end
    end
end