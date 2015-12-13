=begin
Detect single-character XOR
One of the 60-character strings in this file has been encrypted by single-character XOR.
Find it.
(Your code from #3 should help.)
=end
require_relative("Libs/StringFuncs")
require_relative("Libs/XorFuncs")

strList = Array.new

#find the best xor string for each line
File.open("Resources/4.txt","r").readlines().each do |line|
  strLine = hexToBytes([line.chomp])
  strtopush = singleCharXorStr(strLine,singleCharXorChar(strLine).ord)
  strList.push(strtopush)
end

#find the best resulting string
top = 10000
toptext = ""
for l in strList
  puts l + "\t"+ scorePlaintext(l).to_s
  if(scorePlaintext(l)<top)
    top = scorePlaintext(l)
    toptext = l
  end
end

puts toptext
puts scorePlaintext(toptext)