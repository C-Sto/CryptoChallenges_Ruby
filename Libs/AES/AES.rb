=begin
ruby implementation of AES - not to be used in production,
I have no idea what I'm doing
=end

require_relative("../../Libs/AES/KeyExpansion")
require_relative("../../Libs/AES/Rounds")
require_relative("../../Libs/StringFuncs")

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

def aes_ecb_decrypt(input, key)
  output = ""
  (0..(input.length/16)-1).each() do |k|
    begin
      output = output+specLenValToBytes(aes_decrypt_core(stringToHexValues(input[(k*16)..((k*16)+15)]),stringToHexValues(key)),16)
    rescue Exception => msg
      puts "error: " + msg
    end
  end
  return output
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


def aes_cbc_decrypt(ciphertext, key, iv)
  #for every block (starting with the end) decrypt it, then xor it against the previous block.
  # Add this to the plaintext (working backwards)
  #get the chunks
  blocks = chunk(ciphertext,16)
  plaintext = ""
  currentBlock = ""
  (1..blocks.size-1).reverse_each() do |i|

    currentBlock = blocks[i]
    currentBlock = aes_ecb_decrypt(currentBlock,key)
    currentBlock = xor_two_strings_by_bytes(currentBlock, blocks[i-1])
    plaintext = currentBlock+plaintext
  end

  #for the remaining block, decrypt it at the cipher core, then xor it against the iv
  plaintext = xor_two_strings_by_bytes(aes_ecb_decrypt(blocks[0],key),iv) + plaintext
  return plaintext
end