=begin double chiSquare(std::string text, char letter){
  double letCount = std::count(text.begin(), text.end(), letter);
  double expected = 0;
  if (ispunct(letter) || isdigit(letter))
    expected = (0.10 / 100.0)*(text.size());
  else if (freq.count(letter) > 0)
         expected = (freq.at(letter) / 100)*text.size();
       else
         expected = text.size()*0.0001;
         if (expected == 0)
           return 0;
           return(pow((letCount - expected), 2) / expected);
           }

=end

def chiSquare(text, letter)
  text.count(letter)
  expected = 0

end