=begin
double scorePlaintext(std::string s){
	char ca[] = "abcdefghijklmnopqrstuvwxyz \n";
	double tot = 0;
	double val = 0;
	std::vector<char> tested;
	std::vector<char> testable(std::begin(ca), std::end(ca));
	std::string scop(s);
	std::transform(scop.begin(), scop.end(), scop.begin(), ::tolower);
	for (char c : testable){

		val = chiSquare(scop, c);
		tot += val;
		tested.push_back(c);
	}

	for (unsigned char c : s){
		if (std::find(tested.begin(), tested.end(), c) != tested.end())
			continue;
		if (!isprint(c) && c != '\n')
			tot += 200;
		else{
			tot += chiSquare(scop, c);
		}
		tested.push_back(c);
	}

	return tot;
}

=end

def scorePlaintext(text)

  alphabet = "abcdefghijklmnopqrstuvwxyz \n1234567891234567890!@#$%^&*()_+0-=\\][';/.,<>?:\"{}|"
  total = 0
  tested = Array.new
  testable = alphabet.split("")
  text = text.downcase

  for c in testable
      value = chiSquare(text, c)
      total+=value
      tested.push(c)
  end

  for c in text.split("")

    if tested.include? c
      next
    end

    if !isPrint(c) && c != '\n'
      total += text.size*2
    else
      total += chiSquare(text, c)
    end

    tested.push(c)

  end

  return total
end


def chiSquare(text, letter)
  freq = {"a"=>8.167, "b"=>1.492, "c"=>2.782, "d"=>4.253, "e"=>12.702,
          "f"=>2.228, "g"=>2.015, "h"=>6.094, "i"=>6.966, "j"=> 0.153,
          "k"=>0.772, "l"=>4.025, "m"=>2.406, "n"=>6.749, "o"=>7.507,
          "p"=>1.929, "q"=>0.095, "r"=>5.987, "s"=>6.327, "t"=>9.056,
          "u"=>2.758, "v"=>0.978, "w"=>2.360, "x"=>0.150, "y"=>1.974,
          "z"=>0.074, " "=>55.00, "\n"=>0.01, "."=>6.53, ","=>6.16,
          ";"=>0.32,  ":"=>0.34,  "!"=>0.33,  "?"=>0.56, "'"=>2.43,
          '"'=>2.67,  "-"=>1.53}
  #chi square is simply the difference in counted vs expected occurence ratio squared, divided by the expected ratio
  #It will give us a good scoring system for english
  count = text.count(letter)
  expected = 0
  #filter out numbers and punctuation
  if isPunct(letter) || isNumber(letter)
    expected = (0.10/100.0)*(text.size)
    #ensure the character is within our map
  elsif freq.has_key?(letter)
    expected = (freq[letter]/100)*text.size
  #it isn't, so give it a low expected
  else
    expected = text.size*0.0001
  end
  #if something went a bit weird, we still need to return a value
  if expected == 0
    return 0
  end
  #the actual chisquare formula
  return ((count-expected)*(count-expected))/expected
end

def isLetter(char)
  return char=~ /[A-Za-z]/
end

def isNumber(char)
  return char=~/[0-9]/
end

def isPunct(char)
  return char=~/[[:punct:]]/
end

def isPrint(char)
  return char=~/[^[:print:]]/
end