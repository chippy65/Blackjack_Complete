class Cardtable < ActiveRecord::Base

  belongs_to :game
  belongs_to :player_record, :class_name => "User", :foreign_key => 'player_id'
  belongs_to :dealer_record, :class_name => "User", :foreign_key => 'dealer_id'

  serialize :player
  serialize :dealer
  serialize :deck


  def startup(thisplayer)
    # Setup its dealer, player and game associations

    # Find the dealer record and associate it with this cardtable object
    self.dealer_record = User.find(26)
    # Update the number of game sessions for the dealer
    self.dealer_record.num_sessions += 1
    self.dealer_record.save

    # Associate the cardtable player with the logged in user
    self.player_record = thisplayer
    # Update the user information regarding sessions
    self.player_record.num_sessions += 1
    self.player_record.save

    # Create a new game object/record but don't save it just yet
    # as the player may not actually decide to play a game in this session
    @game = self.build_game
    self.game = @game

    # Initialize the game stats for this game
    # We do this here for statistical purposes as it is legal for a session
    # that has no games played
    self.game.user = self.player_record
    self.game.session_num = self.player_record.num_sessions
    self.game.dealer_session_num = self.dealer_record.num_sessions
    self.game.game_num, self.game.dealer_game_num = 0, 0
    self.game.win = false
    self.game.amount = 0
    self.game.num_cards, self.game.dealer_num_cards = 0, 0
    self.game.card_count, self.game.dealer_count = 0, 0

    # Save the game here for testing purposes
#    self.game.save

    # Create a new shuffled desk of cards
    self.deck = Deck.new

    # Create a new dealer object
    self.dealer = Player.new

    # Create a new player object
    self.player = Player.new

    # Set the bet to be 5 initially
    self.bet = 5

  end

  def setBet(amount)
    # Set the bet on the cardtable
    self.bet = amount
  end

  def deal
    # This is the beginning of a new game

    # Clear out any old game data to reset
    if self.game.game_num > 0

      # Reset the game stuff so it can be used later in the method
      self.game.win = false
      self.game.num_cards, self.game.dealer_num_cards = 0, 0
      self.game.card_count, self.game.dealer_count = 0, 0

     # Reset the player and dealer objects
      self.player = self.player.reset
      # If we don't make the second dealer card faceup, then this could be
      # dealt to a player
      self.dealer.hand[1].faceup = true
      self.dealer = self.dealer.reset
    end


    # Deal 2 cards to both the dealer and the player
    self.deck.deal(self.player)
    self.deck.deal(self.player)

    self.deck.deal(self.dealer)
    self.deck.deal(self.dealer)
    # The second card dealt to the dealer is face down
    self.dealer.hand[1].faceup = false

    # Update the number of games played by the player and dealer
    self.player_record.games_played += 1
    self.dealer_record.games_played += 1

    # We subtract the bet from the player and add to the dealer
    # This is in case the player exits the game before it completes
    # When the game completes naturally, we will take this into consideration
    # Think of this as the dealer holding the pot while the game is playing
    self.player_record.balance -= self.bet
    self.dealer_record.balance += self.bet

    # Similarly, we assume that the player will lost and the dealer will win
    # in case the game terminates unexpectedly
    # Again, we will take this into consideration if the game ends normally
    self.player_record.games_lost += 1
    self.dealer_record.games_won += 1

    # Update the games per session average for the player and dealer
    avg = self.player_record.games_played / self.player_record.num_sessions
    if avg < 1
      self.player_record.games_per_session_avg = 1
    else
      self.player_record.games_per_session_avg = avg.floor
    end
    avg = self.dealer_record.games_played / self.dealer_record.num_sessions
    if avg < 1
      self.dealer_record.games_per_session_avg = 1
    else
      self.dealer_record.games_per_session_avg = avg.floor
    end

    self.player_record.save
    self.dealer_record.save

    # Update the game stats
    self.game.game_num = self.player_record.games_played
    self.game.dealer_game_num = self.dealer_record.games_played

    self.game.amount = self.bet

    # We will only update the players cards so that a 0 number of cards
    # for the dealer signifies that the dealer won before playing his hand
    self.game.num_cards = 2
    self.game.card_count = self.player.score.handScore

    self.game.save

  end

  def hit
    # This is where the player gets another card

    # Deal another card to the player
    self.deck.deal(self.player)

    # Update the stats and save
    self.game.num_cards += 1
    self.game.card_count = self.player.score.handScore
    self.game.save

    # If the player is bust then we don't need to do anything - the stats have
    # already been saved and the view will take care of starting a new game 
  end

  def stand
    # This is where the player chooses to stand

    # Give control to the dealer and play its hand
    self.dealer.hand[1].faceup = true

    self.game.dealer_num_cards = 2
    self.game.dealer_count = self.dealer.score.handScore
    self.game.save
  end

  def double
    # This is where the player chooses to double their initial bet

    # Double the bet
    self.setBet(self.bet * 2)
    self.game.amount = self.bet

    # Deal one more card only
    hit

    # If they're not bust, give control to the dealer and play its hand
    if self.player.score.handScore < 22
      stand
    end
  end

  def goDealer
    # This is where we deal to the dealer

    # Deal another card to the player
    self.deck.deal(self.dealer)

    # Update the stats and save
    self.game.dealer_num_cards += 1
    self.game.dealer_count = self.dealer.score.handScore
    self.game.save
  end

  def shuffle
    # Shuffle the deck
    self.deck.shuffle
  end

  def endGame
    # Collect all the dealer cards and players cards and put them
    # to the end of the deck

    # Update the stats for the dealer

    # Update the stats for the player

  end

end

class Player

  attr_accessor :hand, :isawinner, :score

  def initialize
    # Initially, each player has an empty hand of cards and they are assumed
    # to be the loser of the game. This is in case the player kills the game
    # before the end and that player is assumed to have lost.
    self.hand = Array.new
    self.isawinner = false
    self.score = Array.new
  end

  def reset
    # Blow away any old data and star again
    self.hand.clear
    self.score.clear
    Player.new
  end

end

class Card
  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SCORES = %w(2 3 4 5 6 7 8 9 10 10 10 10 11)
  SUITS = %w(Spades Clubs Hearts Diamonds)

  attr_accessor :rank, :score, :suit, :image, :faceup

  def initialize(index)
    # Init the rank, suit, score and image of each card based on the
    # argument passed in
    self.rank = RANKS[index % 13]
    self.score = SCORES[index % 13]
    self.suit = SUITS[index % 4]
    self.image = "/images/" + self.rank + self.suit + ".png"

    # By default, each card is assumed to be dealt face up. When we start
    # playing, only the second card of the dealer will be dealt face down.
    # When it is the dealer's turn to play, this card will be set to be face up
    self.faceup = true
  end

end

class Deck
 
  attr_accessor :cards, :nextcard

  def initialize
    # Create an array of 52 shuffled cards to be the deck
    self.cards = (0..51).to_a.shuffle.collect { |index| Card.new(index) }

    # Set the first card to be dealt as the card at index 0 in the deck
    self.nextcard = 0
  end

  def deal(player)
    # Add the next card in the deck to the player's hand
    player.hand << self.cards[self.nextcard]
    player.score << self.cards[self.nextcard].score.to_i

    # And then increment the position in the deck of the next card to be dealt
    self.nextcard = (self.nextcard + 1) % 52
  end

  def shuffle
    # Shuffle the cards in the deck and set the next card to be dealt
    # as the card at index 0
    self.cards = self.cards.shuffle
    self.nextcard = 0
  end

end

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
