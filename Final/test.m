rep_Txbits = [0  1 0 0 1 0 1 0 1]
parts = 3;
inter = myInterlever(rep_Txbits,parts)
deleav = Deinterleaver(inter,parts)