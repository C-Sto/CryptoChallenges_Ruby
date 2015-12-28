
require("base64")
require_relative("../Libs/XorFuncs")
def hexToBytes(string)
  return string.pack('H*')
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