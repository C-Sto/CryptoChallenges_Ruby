
#discover sets
puts "Sets available:"
sets = Dir.entries(".")
#only print set folders that exist
for x in sets
  if(x[0..2]=="Set")
    puts x
  end
end

puts "Please select a set: "
#chomp to get rid of chars we don't like for printing
set = gets.chomp
#list challenges in selected folder
puts "Challenges available: "
dirs = Dir.entries("./Set "+set)

for x in dirs
  if(x[-1] == 'b')
    puts "\t"+x[0..-4]
  end
end

puts "please select a challenge:"
chal = gets.chomp

#run the challenge
system("ruby \"Set "+set+"/Challenge"+chal+".rb\"")
