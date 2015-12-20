=begin
Fixed XOR
Write a function that takes two equal-length buffers and produces their XOR combination.

If your function works properly, then when you feed it the string:

1c0111001f010100061a024b53535009181c
... after hex decoding, and when XOR'd against:

686974207468652062756c6c277320657965
... should produce:

746865206b696420646f6e277420706c6179
=end

#we can just xor these two hex bases
before = 0x1c0111001f010100061a024b53535009181c
xorTarget = 0x686974207468652062756c6c277320657965

puts "Before:\t" + before.to_s(16)
puts "xorVal:\t" + xorTarget.to_s(16)

#then test against this value
test = 0x746865206b696420646f6e277420706c6179

#xor the things
c = before^xorTarget
puts
puts "Testing.."
#print the result
puts "Target:\t" + test.to_s(16)
puts "Result:\t" + c.to_s(16)
puts "Matches?"
if test == c
  puts "True"
  #print the decoded hex value (to_s() takes a base argument) there might be a quicker way to do this  puts [c.to_s(16)].pack('H*')
else
  puts "fail"
end

