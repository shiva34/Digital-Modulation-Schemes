function inter = myInterlever(rep_Txbits,parts)
    len = length(rep_Txbits);
    inter =[];
    size = len/parts;
    for i=1:size
        % Repeats the bits
        for j=1:parts
            inter = [inter rep_Txbits((j-1)*size + i)];
        end
    end
    inter = inter';
    
end