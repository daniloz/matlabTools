function f = bin2float(bits)
assert(min(size(bits)) == 1) % vector
assert(length(bits) == 32) % 32 elements

signBit = bits(1);
expBits = bits(2:9);
mantBits = bits(10:32);

sign = (-1) ^ signBit;
exp = 2 ^ (bi2de(expBits,'left-msb') - 127);
mantissa = 1 + bi2de(mantBits,'left-msb') * 2^-23;

f = single(sign * mantissa * exp);
