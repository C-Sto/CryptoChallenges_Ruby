=begin
AES in ECB mode
The Base64-encoded content in this file has been encrypted via AES-128 in ECB mode under the key
"YELLOW SUBMARINE".
(case-sensitive, without the quotes; exactly 16 characters;

I like "YELLOW SUBMARINE" because it's exactly 16 bytes long, and now you do too).

Decrypt it. You know the key, after all.

Easiest way: use OpenSSL::Cipher and give it AES-128-ECB as the cipher.

Do this with code.
You can obviously decrypt this using the OpenSSL command-line tool,
but we're having you get ECB working in code for a reason.
You'll need it a lot later on, and not just for attacking ECB.

=end

require_relative("../Libs/AES/AES")
require_relative("../Libs/StringFuncs")
require("base64")
require("openssl")
puts "here we go.."
puts aes_encrypt_core(0x00112233445566778899aabbccddeeff,0x000102030405060708090a0b0c0d0e0f).to_s(16)
puts "69c4e0d86a7b0430d8cdb78070b4c55a"
puts aes_decrypt_core(0x69c4e0d86a7b0430d8cdb78070b4c55a,0x000102030405060708090a0b0c0d0e0f).to_s(16)
puts "00112233445566778899aabbccddeeff"

puts "YSUB"
puts specLenValToBytes(0x0a454c4c4f57205355424d4152494e45,16)
puts 0x38.chr
file = Base64.decode64(File.open("Resources/7.txt").read())
#puts file
#puts [aes_decrypt(file,"YELLOW SUBMARINE")].pack('H*')
decipher =  OpenSSL::Cipher::AES.new(128,:ECB)
decipher.decrypt
decipher.key = "YELLOW SUBMARINE"
plain = decipher.update(file)+decipher.final
puts "This is the value of the ciphertext"
puts stringToHexValues(file).to_s(16)
puts "This is the check value:"
puts stringToHexValues(plain).to_s(16)
puts "This is my value:"
puts aes_decrypt(file,"YELLOW SUBMARINE")

puts "Check block 2"
puts "2072696e67696e27207468652062656c6c20a4120726f6"
