=begin

Convert hex to base64
The string:

49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d
Should produce:

SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
So go ahead and make that happen. You'll need to use this code for the rest of the exercises.

Cryptopals Rule
Always operate on raw bytes, never on encoded strings. Only use hex and base64 for pretty-printing.
=end

require("base64")
require_relative("../Libs/StringFuncs")

#hex representation
hexString = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
puts "Converting Hex to base 64"
puts "Hex string: "+hexString
#target string
testString = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

puts "Target:\t"+testString

#turn to an array
arrayHexString = [hexString]

#unpack and re-encode to base64. Strict is used to avoid linefeeds
ts2 = Base64.strict_encode64(arrayHexString.pack('H*'))

puts "Result:\t"+ts2

#for fun, the plaintext of the string to encode

puts "Plaintext: "

puts hexToBytes(arrayHexString)
