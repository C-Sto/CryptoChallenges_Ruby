=begin
http://www.samiam.org/mix-column.html
  void gmix_column(unsigned char *r) {
    unsigned char a[4];
    unsigned char b[4];
    unsigned char c;
    unsigned char h;
    for(c=0;c<4;c++) {
        a[c] = r[c];
    h = r[c] & 0x80; /* hi bit */
    b[c] = r[c] << 1;
    if(h == 0x80)
      b[c] ^= 0x1b; /* Rijndael's Galois field */
      }
      r[0] = b[0] ^ a[3] ^ a[2] ^ b[1] ^ a[1];
      r[1] = b[1] ^ a[0] ^ a[3] ^ b[2] ^ a[2];
      r[2] = b[2] ^ a[1] ^ a[0] ^ b[3] ^ a[3];
      r[3] = b[3] ^ a[2] ^ a[1] ^ b[0] ^ a[0];
      }
=end

def addRoundKey(inText, key)
  return inText ^ key
end

def subBytes(inText)
  workingVal = inText
  ret = 0
  (0..15).each() do |k|
    thisVal = workingVal&0xFF
    workingVal = workingVal>>8
    ret = (sbox(thisVal)<<8*k)|(ret)
  end
  return ret
end

def getByteAtIndex(inval, index)
  #gets the byte value at the index specified (high bits left)
  #should probably use bitwise operators to do this, rather than converting a bunch of times
  instr = inval.to_s(16)
  if(inval.to_s(16).length%2==1)
    instr = "0"+instr
  end
  return instr[index*2..index*2+1].to_i(16)
end

def putByteAtIndex(inBytes, inByte, index)
  #replaces the byte at the given index with the supplied byte
  #Again, this should probably be done bitwise
  news = inBytes.to_s(16)
  if(news.length%2==1)
    news = "0"+news
  end
  ib = inByte.to_s(16)
  if(inByte.to_s(16).length%2==1)
    ib = "0"+ib
  end
  news[index*2..index*2+1] = ib
  return news.to_i(16)
end

def shiftArrayRowLeft(inputArray, row)
  #create temp variable to store the first element
  #we will return this array
  newArray = []
  (0..inputArray.length-2).each() do |j|
    newArray[j] = putByteAtIndex(inputArray[j], getByteAtIndex(inputArray[j+1], row), row)
  end
  newArray[inputArray.length-1] = putByteAtIndex(inputArray[inputArray.length-1], getByteAtIndex(inputArray[0], row), row)
  return newArray
end

def shiftRows(inText)
  #create columns
  working = inText
  columns = getcolumns(working)

  (1..3).each() do |j|
    #row 0 does not get moved
    #for each remaining row, shift by row number (shift row 1 by 1 place, row 2 etc)
    (1..j).each() do |k|
      columns = shiftArrayRowLeft(columns, j)
    end
  end
  #reconstruct the state
  out = columns[0]<<96 | columns[1] << 64 | columns[2] << 32 | columns[3]
  return out

end

def getcolumns(invals)
  columns = []
  (0..3).reverse_each() do |n|
    columns[3-n]=((invals >> 32*n)&0xFFFFFFFF)
  end
  return columns
end

def mixColumns(inText)
  #multiply each column
  #2 3 1 1
  #1 2 3 1
  #1 1 2 3
  #3 1 1 2
  columns = getcolumns(inText)
  (0..columns.length-1).each() do |k|
    columns[k] = gmix_column(columns[k])
  end
  out = columns[0]<<96 | columns[1] << 64 | columns[2] << 32 | columns[3]
  return out

end

def gmix_column(inBytes)
  a = 0x0000
  b = 0x0000
  (0..3).each() do |k|
    a = putByteAtIndex(a, getByteAtIndex(inBytes, k), k)
    h = getByteAtIndex(inBytes, k)&0x80
    b = putByteAtIndex(b, (getByteAtIndex(inBytes, k)<< 1)&0xFF, k)
    if (h==0x80)
      b = putByteAtIndex(b, 0x1b ^ getByteAtIndex(b, k), k)
    end
  end
  r =             getByteAtIndex(b,0)^getByteAtIndex(a,3)^getByteAtIndex(a,2)^getByteAtIndex(b,1)^getByteAtIndex(a,1)
  r = (r << 8) | getByteAtIndex(b,1)^getByteAtIndex(a,0)^getByteAtIndex(a,3)^getByteAtIndex(b,2)^getByteAtIndex(a,2)
  r = (r << 8) | getByteAtIndex(b,2)^getByteAtIndex(a,1)^getByteAtIndex(a,0)^getByteAtIndex(b,3)^getByteAtIndex(a,3)
  r = (r << 8) | getByteAtIndex(b,3)^getByteAtIndex(a,2)^getByteAtIndex(a,1)^getByteAtIndex(b,0)^getByteAtIndex(a,0)
  return r
end