def rot(val)
  return rotL(val)
end

def rotL(val)
  return ((val << 8) | (val >> (24))) & 0xFFFFFFFF
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

def finiteInv(val)
  (0..255).each() do |i|
    if(finMult(i,val)==1)
      return i
    end
  end
  return 0
end

def transform(val)
  #    Store the multiplicative inverse of the input number in two 8-bit unsigned temporary variables: s and x.
  inverse = finiteInv(val)
  s = inverse
  x = inverse
  #    Rotate the value s one bit to the left;
  #     if the value of s had a high bit (eighth bit from the right) of one,
  #     make the low bit of s one; otherwise the low bit of s is zero.
  (0..3).each() do
    s = ((s<<1)|(s>>7))&0xFF
    x = s^x
  end
  return x
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
  return transform(inVal)^99

end

def core(inval, i)
  #Use rotate to rotate the output eight bits to the left
  ret = rotL(inval)
  #Apply Rijndael's S-box on all four individual bytes in the output word.
  b4 = ret & 0xFF
  b3 = (ret & 0xFF00)>>8
  b2 = (ret & 0xFF0000)>>16
  b1 = (ret & 0xFF000000)>>24
  box1 = (sbox(b1)^rcon(i))<<24
  box2 = sbox(b2)<<16
  box3 = sbox(b3)<<8
  box4 = sbox(b4)
  #On just the first (leftmost, MSB) byte of the output word, exclusive or the byte with 2 to the power of i (rcon(i)).
  ret = box1+box2+box3+box4
  return ret
end

def countKeyBites(ary)
  rval = 0
  ary.each() do |i|
    rval+=i.size()
  end
  return rval
end

def keySchedule(key)
  #Constants[edit]
  #Since the key schedule for 128-bit, 192-bit, and 256-bit encryption are very similar,
  # with only some constants changed, the following keysize constants are defined here:
  #n has a value of 16 for 128-bit keys, 24 for 192-bit keys, and 32 for 256-bit keys
  #b has a value of 176 for 128-bit keys, 208 for 192-bit keys,
  # and 240 for 256-bit keys (with 128-bit blocks as in AES,
  n = 0
  b = 0
  n = case (key.to_s(16).length/2)
        when 0..16
          n = 16
          b = 176
        when 17..24
          n = 24
          b = 208
        when 25..32
          n = 32
          b = 240
      end
  ret = Array.new
  #The first n bytes of the expanded key are simply the encryption key.
  ret.push(key)
  #    The rcon iteration value i is set to 1
  i = 1
  #Until we have b bytes of expanded key, we do the following to generate n more bytes of expanded key:
  keybytes = countKeyBites(ret)
  while(keybytes!=b)
  #   We do the following to create 4 bytes of expanded key:
  #   We create a 4-byte temporary variable,
  #   We assign the value of the previous four bytes in the expanded key to t
    tVal = ret[i-1] & 0xFFFFFFFF #gets last 4 bytes of previous key expansion
  #   We perform the key schedule core (see above) on t, with i as the rcon iteration value
    tVal = core(tVal,i)
  #   We increment i by 1
    i+=1
  #   We exclusive-OR t with the four-byte block n bytes before the new expanded key. This becomes the next 4 bytes in the expanded key
    tVal = tVal ^ (ret[i-2]>>96)
    firstFour = tVal
  #We then do the following three times to create the next twelve bytes of expanded key:
    (0..2).each() do |k|
      #   We assign the value of the previous 4 bytes in the expanded key to t
      #   We exclusive-OR t with the four-byte block n bytes before the new expanded key. This becomes the next 4 bytes in the expanded key
      tVal = tVal ^ (ret[i-2]>>(32*(2-k))&0xFFFFFFFF)
      firstFour = (firstFour << 32)|tVal
      #If we are processing a 256-bit key, we do the following to generate the next 4 bytes of expanded key:
      #   We assign the value of the previous 4 bytes in the expanded key to t
      #   We run each of the 4 bytes in t through Rijndael's S-box
      #   We exclusive-OR t with the 4-byte block n bytes before the new expanded key. This becomes the next 4 bytes in the expanded key.
      #If we are processing a 128-bit key, we do not perform the following steps. If we are processing a 192-bit key, we run the following steps twice.
      #   If we are processing a 256-bit key, we run the following steps three times:
      #   We assign the value of the previous 4 bytes in the expanded key to t
      #   We exclusive-OR t with the four-byte block n bytes before the new expanded key. This becomes the next 4 bytes in the expanded key
    end
    ret.push(firstFour)
  keybytes = countKeyBites(ret)
  end
  return ret
end