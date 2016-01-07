
require_relative("../../Libs/AES/KeyExpansion")
def addRoundKey(inText, key)
    return inText ^ key
end

def subBytes(inText)
    workingVal = inText
    ret = 0
    (0..15).each() do  |k|
      thisVal = workingVal&0xFF
      workingVal = workingVal>>8
      ret = (sbox(thisVal)<<8*k)|(ret)
    end
  return ret
end

def shiftRows(inText)
  #break into rows
    #create columns
  working = inText
  columns = []
  rows = []
  ctr = 3
  (0..3).reverse_each() do |n|
    columns[n]=((working >> 32*n)&0xFFFFFFFF)
  end
  (0..3).each() do |n|
    rval = 0
    columns.each() do |i|
      puts rval.to_s(16)
      rval = rval|columns[n]
    end
    rows[n] = rval
  end
  rows.each() do |k|
    puts k.to_s(16) + " val"
  end
    #assign same column place to corresponding row
  #row 0 does not get moved
  #for each remaining row, shift by row number (shift row 1 by 1 place, row 2 etc)
  return inText

end

def mixColumns(inText, key)

end