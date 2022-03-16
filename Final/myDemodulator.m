% The demodulator function

function Demod = myDemodulator(received,num_sym,mod_type)

%initialising vector to store decided bits(either 1 or 2)
decisions=zeros(num_sym,1);
rxBits=zeros(num_sym,1);
if strcmp(mod_type,"BPSK")
    range = [zeros(1,1);ones(1,1)];
    constellation = exp(1i*2*pi.*range/2);
     
    for n=1:num_sym 
            % CollectionPoint distance(absolute value)
            distances = abs(received(n)-constellation); 
            % Checking the minimum of the distances from points and storing
            [~,decisions(n)] = min(distances);
    end 
    %mapping the decision value to bit which will be received at the receiver
    for n=1:num_sym 
            if decisions(n)~=1
                rxBits(n)=1;
            else
                rxBits(n)=0;
            end
    end
elseif strcmp(mod_type,"4QAM")
    constellation = [1+1i*1 -1+1i*1 1-1i*1 -1-1i*1]; 
    for n=1:num_sym 
            % CollectionPoint distance(absolute value)
            distances = abs(received(n)-constellation); 
            % Checking the minimum of the distances from points and storing
            [~,decisions(n)] = min(distances);
    end
    for i=1:num_sym
        rxBits(i) = decisions(i) - 1;
    end
    

           
elseif strcmp(mod_type,"16QM")
constellation = [1+1i*1 1+1i*3 3+1i*1 3+1i*3 -1+1i*1 -1+1i*3 -3+1i*1 -3+1i*3 1-1i*1 1-1i*3 3-1i*1 3-1i*3 -1-1i*1 -1-1i*3 -3-1i*1 -3-1i*3]/sqrt(4);
for n=1:num_sym 
        % CollectionPoint distance(absolute value)
        distances = abs(received(n)-constellation); 
        % Checking the minimum of the distances from points and storing
        [~,decisions(n)] = min(distances);
end
for i=1:num_sym
    rxBits(i) = decisions(i) - 1;
end
end
%demodulated bits
Demod = rxBits;
end