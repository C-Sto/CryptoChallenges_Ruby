=begin
ruby implementation of AES - not to be used in production,
I have no idea what I'm doing
=end
require_relative("../../Libs/AES/KeyExpansion")
require_relative("../../Libs/AES/Rounds")
#key expansion
puts "RconTest: "
puts rcon(10).to_s(16) + " Should be 0x36"
puts rcon(0).to_s(16) + " should be 0x8d"
puts "Sbox test:"
puts sbox(0x53).to_s(16) + " should be ed"
puts "core test:"
puts (core(0x0c0d0e0f,1)^0x00010203).to_s(16)+ " should be d6aa74fd"
puts "Key Schedule test"

keySchedule(0x6920e299a5202a6d656e636869746f2a).each() do |k|
  puts k.to_s(16)
end
=begin
For the key 69 20 e2 99 a5 20 2a 6d 65 6e 63 68 69 74 6f 2a, the expanded key is:
69 20 e2 99 a5 20 2a 6d 65 6e 63 68 69 74 6f 2a
fa 88 07 60 5f a8 2d 0d 3a c6 4e 65 53 b2 21 4f
cf 75 83 8d 90 dd ae 80 aa 1b e0 e5 f9 a9 c1 aa
18 0d 2f 14 88 d0 81 94 22 cb 61 71 db 62 a0 db
ba ed 96 ad 32 3d 17 39 10 f6 76 48 cb 94 d6 93
88 1b 4a b2 ba 26 5d 8b aa d0 2b c3 61 44 fd 50
b3 4f 19 5d 09 69 44 d6 a3 b9 6f 15 c2 fd 92 45
a7 00 77 78 ae 69 33 ae 0d d0 5c bb cf 2d ce fe
ff 8b cc f2 51 e2 ff 5c 5c 32 a3 e7 93 1f 6d 19
24 b7 18 2e 75 55 e7 72 29 67 44 95 ba 78 29 8c
ae 12 7c da db 47 9b a8 f2 20 df 3d 48 58 f6 b1
=end

#rounds
puts "Rounds test:"
input = 0x3243f6a8885a308d313198a2e0370734
key = keySchedule(0x2b7e151628aed2a6abf7158809cf4f3c)
state = addRoundKey(input,key[0])
puts state.to_s(16)
puts "193de3bea0f4e22b9ac68d2ae9f84808 verify round key operation"

state = subBytes(state)

puts state.to_s(16)
puts "d42711aee0bf98f1b8b45de51e415230 verify sub bytes operation"

state = shiftRows(state)
#puts state.to_s(16)

puts ""

#final round (no mix)
