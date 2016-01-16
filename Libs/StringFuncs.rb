
require("base64")
require_relative("../Libs/XorFuncs")
def hexToBytes(string)
  return string.pack('H*')
end

def specLenHexStringToBytes(inVal,hexLen)
  str = inVal
  while(str.length<hexLen*2)
    str="0"+str
  end
  return [str].pack('H*')
end

def specLenValToBytes(inHex,hexLen)
  return specLenHexStringToBytes(inHex.to_s(16),hexLen)
end

def stringToHexValues(inString)
  outString = ""
  inString.each_byte() do |k|
    outString = k.to_s(16).length < 2 ? outString+"0"+k.to_s(16) : outString+k.to_s(16)
  end
  return outString.to_i(16)
  #return (inString.each_byte.map {|b| b.to_s(16)}.join).to_i(16)
end

def hammingDistance(in_str1, in_str2)
  count = 0
  if(in_str1.class == String && in_str2.class == String)
    for i in 0..in_str1.size-1
      count+= (in_str1[i].ord ^ in_str2[i].ord).ord.to_s(2).count("1")
    end
    return count
  end
end

def chunk(input, chunk_size)
  #splits an input into chunks of specified size
  #outputs an array of chunks
  count = 0
  out = Array.new
  (0..input.size()).step(chunk_size) do |i|
    count+=1
    out.push(input[i..i+chunk_size-1])
  end
  return out
end

def transpose(input)
  ret = Array.new
  #returns an array of transposed values (first element of every array in one, second in two, etc)
  (0..input[0].size()-1).each() do |k|
    ta = ""
    (0..input.size()-1).each() do |l|
      if(input[l][k])
        ta += input[l][k]
      end
    end
    ret.push(ta)
  end
  return ret
end

def detect_ecb(input)
  #takes a hex string input and looks for ECB by mapping duplicate blocks
  zz = []
  (0..input.length/32).each() do |i|
    zz.push(input[i*32..(i*32)+31])
  end
  return !(zz.uniq.length == zz.length)
end

def pkcs7_pad(unpadded, blockSize)
  padded = unpadded
  padLen = unpadded.length
  while(padLen>blockSize)
    padLen = padLen-blockSize
  end
  bytesToPad = blockSize%padLen
  puts bytesToPad
  (1..bytesToPad).each() do
    padded = padded + bytesToPad.chr
  end
  return padded
end