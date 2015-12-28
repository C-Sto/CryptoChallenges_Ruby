=begin

=end

def rot(val)
  return rotL(val)
end

def rotL(val)
  return ((val << 8) | (val >> (32-8))) & 0xFFFFFFFF
end

def rotR

end

def finMult(a, b)
  p = 0
  (0..7).each do |k|
    #If the rightmost bit of b is set, exclusive OR the product p by the value of a. This is polynomial addition.
    if(b%2==1)
      p = p^a
    end
    #shift B one bit to the right, discard rightmost bit and leftmost bit = 0.
    b = b >> 1
    carry = 0
    #if leftmost bit of a is 1, call it carry
    if((0x80&a)==0x80)
      carry = 1
    end

    #Shift a one bit to the left, discarding the leftmost bit,
    #and making the new rightmost bit zero. This multiplies the polynomial by x,
    #but we still need to take account of carry which represented the coefficient of x7.
    a = (a<<1)&0xFF

    #If carry had a value of one, exclusive or a with the hexadecimal number 0x1b (00011011 in binary).
    #0x1b corresponds to the irreducible polynomial with the high term eliminated. Conceptually,
    # the high term of the irreducible polynomial and carry add modulo 2 to 0.
    if(carry==1)
      a = a^0x1b
    end
  end
  return p

end

def finInv(val)

end

def rcon(inVal)
  #doing rcon(0) doesn't work, never called, but for completeness
  if(inVal == 0)
    return 0x8d
  end
  tot = 1
  (2..inVal).each() do |v|
    tot = finMult(2,tot)
  end
  return tot
end

def sbox(inVal)

end