=begin
ruby implementation of AES - not to be used in production,
I have no idea what I'm doing
=end
require_relative("../../Libs/AES/KeyExpansion")
#key expansion
puts rotL(0x1D2C3A4F).to_s(16)
puts 0x2C3A4F1D.to_s(16)

puts rcon(1).to_s(16) + " Should be 0x01"
puts rcon(2).to_s(16) + " Should be 0x02"
puts rcon(3).to_s(16) + " Should be 0x04"
puts rcon(9).to_s(16) + " Should be 0x1b"
puts rcon(10).to_s(16) + " Should be 0x36"
puts rcon(0).to_s(16) + " should be 0x8d"
#rounds

#final round (no mix)
