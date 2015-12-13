require_relative("TextAnalysis")

def singleCharXorChar(xor_str)
  #returns a char that when xord against the supplied ciphertext results in english-like plaintext
  #keep a highest number variable
  highest = 0
  highestText = ''
  highestChar = 0
  #iterate over each byte (0-255)
  for i in 0..255
    #score the string
    this_text = singleCharXorStr(xor_str,i)
    score = scorePlaintext(this_text)
    #remember highest score
    if score>highest
      highest = score
      highestText = this_text
      highestChar = i.chr
    end
  end
  return highestChar
end

def singleCharXorStr(xor_str, xor_chr)
  #returns a string xor'd against a single(repeating)char
  ret=""
  xor_str.each_byte do |c|
    ret+= (c^xor_chr).chr
  end
  return ret
end