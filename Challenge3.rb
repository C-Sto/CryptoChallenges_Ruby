=begin
The hex encoded string:
1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
... has been XOR'd against a single character. Find the key, decrypt the message.
You can do this by hand. But don't: write code to do it for you.
How? Devise some method for "scoring" a piece of English plaintext. Character frequency is a good metric.
Evaluate each output and choose the one with the best score.
=end

require_relative("Libs/StringFuncs")
require_relative("Libs/XorFuncs")

#functionize things


hexString = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

byteString = hexToBytes([hexString])

#print results
puts "Xor key: "+singleCharXorChar(byteString)
puts "Resultant plaintext: "+singleCharXorStr(byteString,singleCharXorChar(byteString).ord)
