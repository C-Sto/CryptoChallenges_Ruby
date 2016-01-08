=begin
ruby implementation of AES - not to be used in production,
I have no idea what I'm doing
=end

require_relative("../../Libs/AES/KeyExpansion")
require_relative("../../Libs/AES/Rounds")


def aes_core(inputBytes,key)
  expandedKey = keySchedule(key)
  #initial
  state = addRoundKey(inputBytes,expandedKey[0])
  #change this to variable rounds for 192, 256 etc
  (1..9).each() do |k|
    state = subBytes(state)
    state = shiftRows(state)
    state = mixColumns(state)
    state = addRoundKey(state,expandedKey[k])
  end
  #final round
  state = subBytes(state)
  state = shiftRows(state)
  state = addRoundKey(state,expandedKey[10])
  return state
end

#key expansion
#rounds
#final round (no mix)
