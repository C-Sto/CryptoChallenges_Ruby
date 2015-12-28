=begin
ruby implementation of AES - not to be used in production,
I have no idea what I'm doing
=end
require_relative("../../Libs/AES/KeyExpansion")
#key expansion
puts "RconTest: "
puts rcon(10).to_s(16) + " Should be 0x36"
puts rcon(0).to_s(16) + " should be 0x8d"
puts "Sbox test:"
puts sbox(0x53).to_s(16) + " should be ed"
puts "core test:"
puts (core(0x0c0d0e0f,1)^0x00010203).to_s(16)+ " should be d6aa74fd"
puts 0x000102030405060708090a0b0c0d0e0f.to_s(16).length/2
#rounds

#final round (no mix)
