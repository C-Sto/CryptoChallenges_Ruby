=begin
ruby implementation of AES - not to be used in production,
I have no idea what I'm doing
=end

require_relative("../../Libs/AES/KeyExpansion")
require_relative("../../Libs/AES/Rounds")

def aes_encrypt(input, key)
  #check for string, if string, turn it into number for aes
  if(input.class == String)
    verifiedInput = input.bytes.join().to_i(16)
  else
    verifiedInput = input
  end

  if(key.class == String)
    verifiedKey = key.bytes.join().to_i(16)
  else
    verifiedKey = key
  end
  aes_encrypt_core(verifiedInput,verifiedKey)
end


def aes_encrypt_core(inputBytes,key)
  expandedKey = keySchedule(key)
  #initial
  state = addRoundKey(inputBytes,expandedKey[0])
  #change this to variable rounds for 192, 256 etc
  (1..9).each() do |k|
    state = subBytes(state)
    state = shiftRows(state)
    state = mixColumns(state)
    state = addRoundKey(state,expandedKey[k])
  end
  #final round
  state = subBytes(state)
  state = shiftRows(state)
  state = addRoundKey(state,expandedKey[10])
  return state
end

def aes_decrypt_core(inputBytes, key)
  expandedKey = decKeySchedule(key)
  #initial
  state = addRoundKey(inputBytes,expandedKey[10])

  (1..9).reverse_each() do |k|
    state = invShiftRows(state)
    state = invSubBytes(state)
    state = addRoundKey(state,expandedKey[k])
    state = invMixColumns(state)
  end
  state = invShiftRows(state)
  state = invSubBytes(state)
  state = addRoundKey(state,expandedKey[0])
  return state
end
#key expansion
#rounds
#final round (no mix)
