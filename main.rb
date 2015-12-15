

set = ""

chal = ""

puts "please select a set: "
set = gets.chomp
puts "please select a challenge: "
chal = gets.chomp

system("ruby \"Set "+set+"\\Challenge"+chal+".rb\"")