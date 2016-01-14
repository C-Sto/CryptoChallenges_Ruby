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

def invTransform(val)
  inverse = val
  s = inverse
  x = inverse
  (0..3).each() do
    #   2 Rotate the value s one bit to the left;
    #      if the value of s had a high bit (eighth bit from the right) of one,
    #      make the low bit of s one; otherwise the low bit of s is zero.
    s = ((s<<1)|(s>>7))&0xFF
    #   3 XOR the value of x with the value of s, storing the value in x
    #For three more iterations, repeat steps two and three; steps two and three are done a total of four times.
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

def invSbox(inVal)
=begin
  Until I can work out how to reverse s-box, going to have to do a lookup :(
  state = inVal
  puts state.to_s(16)+ " Initial"
  #first we remove the xor
  state = inVal^5
  puts state.to_s(16)+ " xor"
  #then we do the transform
  state = invTransform(state)
  puts state.to_s(16)
  return state
  #then we get the inverse
  state = finiteInv(state)
  puts state.to_s(16)+ " invert"

  return state
=end
  inverted =
  [
      0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB,
      0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB,
      0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E,
      0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25,
      0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92,
      0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84,
      0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06,
      0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B,
      0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73,
      0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E,
      0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B,
      0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4,
      0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F,
      0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF,
      0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61,
      0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D
  ]

  return inverted[inVal]

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

def countKeyBytes(ary)
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
  case (key.to_s(16).length/2)
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
  keybytes = n
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
    keybytes+=4
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
  keybytes+=12
  end
  return ret
end

def decKeySchedule(key)
  #Constants[edit]
  #Since the key schedule for 128-bit, 192-bit, and 256-bit encryption are very similar,
  # with only some constants changed, the following keysize constants are defined here:
  #n has a value of 16 for 128-bit keys, 24 for 192-bit keys, and 32 for 256-bit keys
  #b has a value of 176 for 128-bit keys, 208 for 192-bit keys,
  # and 240 for 256-bit keys (with 128-bit blocks as in AES,
  n = 0
  b = 0
  case (key.to_s(16).length/2)
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
  keybytes = n
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
    keybytes+=4
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
    keybytes+=12
  end
=begin
Nb = number of columns. For AES this = 4
Nk = number of words in the key. For AES, this = 4,6 or 9 (4 for 128)
Nr = number of rounds (10 for 128)
  for i = 0 step 1 to (Nr+1)*Nb-1
  dw[i] = w[i]
  end for
  for round = 1 step 1 to Nr-1
  InvMixColumns(dw[round*Nb, (round+1)*Nb-1]) // note change of type
end for
=end
  #for i = 0 step 1 to (Nr+1)*Nb-1
  (0..(10+1)*(4-1)).each() do |i|
    #dw[i] = w[i]
    #end for
  end
  #for round = 1 step 1 to Nr-1
  (1..9).each() do |i|
    #InvMixColumns(dw[round*Nb, (round+1)*Nb-1])
    #ret[i] = invMixColumns(ret[i])
    #end for
  end

  return ret
end