% The modulator function 

function mod_Sym = myModulator(TxBits,mod_type)

if strcmp(mod_type,"BPSK")
    % BPSK constellation definition
    constellation = exp(1i*2*pi.*TxBits/2);
    constellation = constellation';


    % Code for QPSK constellation definition
elseif strcmp(mod_type,"4QAM")
    range = [1+1i*1 -1+1i*1 1-1i*1 -1-1i*1]/sqrt(2);
    constellation = range(TxBits+1);
    %code for 16QAM constellation definition
elseif strcmp(mod_type,"16QM")
    range = [1+1i*1 1+1i*3 3+1i*1 3+1i*3 -1+1i*1 -1+1i*3 -3+1i*1 -3+1i*3 1-1i*1 1-1i*3 3-1i*1 3-1i*3 -1-1i*1 -1-1i*3 -3-1i*1 -3-1i*3]/sqrt(4);
    constellation = range(TxBits(:)+1);
end
mod_Sym = constellation;   

end