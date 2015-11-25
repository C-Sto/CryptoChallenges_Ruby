require("base64")

#hex representation
hexString = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
#target string
testString = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

#turn to an array
arrayHexString = [hexString]

#unpack and re-encode to base64. Strict is used to avoid linefeeds
ts2 = Base64.strict_encode64(arrayHexString.pack('H*'))

puts ts2

puts testString

puts ts2 == testString

#for fun, the plaintext of the string to encode

puts ""

puts arrayHexString.pack('H*')
