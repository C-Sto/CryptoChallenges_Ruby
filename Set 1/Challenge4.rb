=begin
Detect single-character XOR
One of the 60-character strings in this file has been encrypted by single-character XOR.
Find it.
(Your code from #3 should help.)
=end
require_relative("../Libs/StringFuncs")
require_relative("../Libs/XorFuncs")

strList = Array.new

puts "Opening file, and determining most likely single char xor of each.."
puts "This may take some time."
STDOUT.flush

#find the best xor string for each line
File.open("Resources/4.txt","r").readlines().each do |line|
  strLine = hexToBytes([line.chomp])
  strtopush = singleCharXorStr(strLine,singleCharXorChar(strLine).ord)
  print "\rLoaded: "+strtopush.scan(/[[:print:]]/).join
  STDOUT.flush
  strList.push(strtopush)
end
puts "File loaded"
puts "Finding best string from selection.."
#find the best resulting string
top =10000
toptext = ""
puts "Searching strings.."
STDOUT.flush
for l in strList
  puts l + "\t"+ scorePlaintext(l).to_s
  if(scorePlaintext(l)<top)
    top = scorePlaintext(l)
    toptext = l
  end
end
puts "Finished, printing winner, and score"
puts toptext
puts scorePlaintext(toptext)