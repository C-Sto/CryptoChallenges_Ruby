=begin
Detect AES in ECB mode
In this file are a bunch of hex-encoded ciphertexts.

One of them has been encrypted with ECB.

Detect it.

Remember that the problem with ECB is that it is stateless and deterministic;
the same 16 byte plaintext block will always produce the same 16 byte ciphertext.
=end

require_relative("../Libs/TextAnalysis")

strList = []
File.open("Resources/8.txt","r").readlines().each do |line|
  strList.push(line)
end

(0..strList.length-1).each() do |s|
  if detect_ecb(strList[s])
    puts "ECB Detected on line " + s.to_s
  end
end

