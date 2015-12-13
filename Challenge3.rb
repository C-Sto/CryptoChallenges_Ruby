=begin
The hex encoded string:
1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
... has been XOR'd against a single character. Find the key, decrypt the message.
You can do this by hand. But don't: write code to do it for you.
How? Devise some method for "scoring" a piece of English plaintext. Character frequency is a good metric.
Evaluate each output and choose the one with the best score.
=end

require_relative("Libs/TextAnalysis")
require_relative("Libs/StringFuncs")

hexString = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

byteString = hexToBytes([hexString])

#keep a highest number variable
highest = 0
highestText = ''
highestChar = 0

#iterate over each byte (0-255)
for i in 0..255
  testString = ''
  #create new string from byte and xor of each character
  byteString.each_byte do |c|
     testString+=(c^i).chr
  end
  #score the string
  score = scorePlaintext(testString)
  #remember highest score
  if score>highest
    highest = score
    highestText = testString
    highestChar = i.chr
  end
end

#print results
puts "Highest plaintext score: " +highest.to_s
puts "Resultant plaintext: "+highestText
puts "Xor key: "+highestChar
