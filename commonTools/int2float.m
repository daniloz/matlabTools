function f = int2float(int)
assert(ceil(log2(int)) <= 32) % 32 bits, not more

f = bin2float(de2bi(int,32,'left-msb'));
