
#we can just xor these two hex bases
before = 0x1c0111001f010100061a024b53535009181c
xorTarget = 0x686974207468652062756c6c277320657965

#then test against this value
test = 0x746865206b696420646f6e277420706c6179
#xor the things
c = before^xorTarget

#print the result
if test == c
  puts "True"
  #print the decoded hex value (to_s() takes a base argument) there might be a quicker way to do this  puts [c.to_s(16)].pack('H*')
else
  puts "fail"
end

