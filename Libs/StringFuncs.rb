
require("base64")
require_relative("../Libs/XorFuncs")
def hexToBytes(string)
  return string.pack('H*')
end

def hammingDistance(in_str1, in_str2)
  puts in_str2
  puts in_str1
  count = 0
  if(in_str1.class == String && in_str2.class == String)
    for i in 0..in_str1.size-1
      count+= (in_str1[i].ord ^ in_str2[i].ord).ord.to_s(2).count("1")
    end
    return count
  end
end