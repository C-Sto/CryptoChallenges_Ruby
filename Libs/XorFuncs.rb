require_relative("TextAnalysis")
require_relative("StringFuncs")

def singleCharXorChar(xor_str)
  #returns a char that when xord against the supplied ciphertext results in english-like plaintext
  #keep a Lowest number variable
  lowest = 99999999999
  lowestText = ''
  lowestChar = 0
  #puts "Cracking.."
  #iterate over each byte (0-255)
  for i in 0..255
    #score the string
    this_text = singleCharXorStr(xor_str,i)
    score = scorePlaintext(this_text)
    #remember lowest score
    if score<lowest
      lowest = score
      lowestText = this_text
      lowestChar = i.chr
    end
  end
  #puts "cracking complete"
  #puts "most likely char: "+lowestChar
  return lowestChar
end

def singleCharXorStr(xor_str, xor_chr)
  #returns a string xor'd against a single(repeating)char
  ret=""
  xor_str.each_byte do |c|
    ret+= (c^xor_chr).chr
  end
  return ret
end

def repeatingKeyXor(plain, key)
  #returns a string xor'd against a repeating set of chars
  count = 0
  ret = ""
  plain.each_byte do |c|
    ret+=( c ^ key[count].ord ).chr
    if count == key.size-1
      count = 0
    else
      count += 1
    end
  end
  return ret
end

def xor_two_strings_by_bytes(str1, str2)
  return hexToBytes([(stringToHexValues(str1)^stringToHexValues(str2)).to_s(16)])
end