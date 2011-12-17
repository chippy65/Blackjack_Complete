
class Array
  # Extend the Array class to create a handScore method
  # It sorts the array so that the Aces are at the end. Aces are initially
  # assumed to have a score of 11. Basically, if the score of the hand
  # is > 21 and we're working with an Ace, make the ace 1 not 11. Also, if
  # we encounter an Ace and we're not at the end of the hand, we take that
  # into consideration by subtracting the value of the remaining Aces. Only
  # really for the unlikely event we get a 10 an Ace and another Ace
 
  def handScore
    sort.each_with_index.inject(0){|sum, (current, i)| sum+current > 21-(length-(i+1)) && current==11 ? sum+1 : sum+current}

  end
end
