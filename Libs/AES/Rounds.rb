
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

def getByteAtIndex(inval,index)
  #gets the byte value at the index specified (high bits left)
  #should probably use bitwise operators to do this, rather than converting a bunch of times
  #remove the byte
  return inval.to_s(16)[index*2..index*2+1].to_i(16)
end

def putByteAtIndex(inBytes, inByte, index)
  #replaces the byte at the given index with the supplied byte
  #Again, this should probably be done bitwise
  news = inBytes.to_s(16)
  news[index*2..index*2+1] = inByte.to_s(16)
  return news.to_i(16)
end

def shiftArrayRowLeft(inputArray, row)
  #create temp variable to store the first element
  temp = 0x00
  #we will return this array
  newArray = []
  (0..inputArray.length-2).each() do |j|
    temp = getByteAtIndex(inputArray[j],row)
  end
  puts "Shift"
  newArray.each() do |k|
    puts k.to_s(16)
  end
  puts "endShift"
  return newArray
end

def shiftRows(inText)
  #break into rows
    #create columns
  working = inText
  columns = []
  rows = [0,0,0,0]
  ctr = 3
  (0..3).reverse_each() do |n|
    columns[3-n]=((working >> 32*n)&0xFFFFFFFF)
  end
  (1..3).each() do |j|
    #row 0 does not get moved
    #for each remaining row, shift by row number (shift row 1 by 1 place, row 2 etc)
    #iter 1 = element 1 of column 0 moves to element 1 of column 3. all other columns move up to fill
      #element 1 of column 1 moves to column 0 etc
    #iter 2 = perform the above shift twice
  end
  shiftArrayRowLeft(columns,1)
  columns.each() do |k|
    puts k.to_s(16)
  end
  return inText

end

def mixColumns(inText, key)

end