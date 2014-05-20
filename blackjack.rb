#Requirements for Blackjack game:
#
#1. We need a deck of cards to play the game !!!DONE!!! (deck + cards)
#2. Players: a Player and a Dealer
#3. Shuffle the deck before the start !!!DONE!!! (within Deck initialize)
#4. Game starts
#5. Each player gets initially dealt 2 cards to his/her hand !!!DONE!!!
#6. Players turn
#  Determine players hand value:
#  - as long as his hand value is less than 21, he can choose to hit or stand
#  - if he chooses to hit, he gets dealt another cards
#  - if he decides to stand, move to the dealers turn
#  - if his score is 21, he hits Blackjack and wins (end of game)
#  - if his score is higher than 21, he goes bust and loses (end of game)
#7. Dealers turn
#  Determine dealers hand value:
#  - as long as his hand value is less than 17, he has to hit
#  - if his score is 17 or more, he has to stand
#  - if his score is 21, he hits Blackjack and wins (end of game)
#  - if his score is higher than 21, he goes bust and loses (end of game)
#8. Determine the winner
#  - if players score is higher than dealers score, player wins
#  - if dealers score is higher than players score, dealer wins
#  - if their score is the same, its a tie

#Nouns (likely classes):
#  Game 
#  Card !!!DONE!!!
#  Deck !!!DONE!!!
#  Hand --> Player !!!DONE!!!
#  Human Player
#  Dealer
#  Value (?)

#Verbs (likely methods):
#  shuffle
#  deal
#  hit
#  stand

SUITS = ['C', 'D', 'H', 'S']
RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

# for nice output purposes
SUITS_PRINTS = {'C' => 'Clubs', 'D' => 'Diamonds', 'H' => 'Hearts', 'S' => 'Spades'}
RANKS_PRINTS = {'2' => 'Deuce', '3' => 'Three', '4' => 'Four', '5' => 'Five', 
                '6' => 'Six', '7' => 'Seven', '8' => 'Eight', '9' => 'Nine', 
                '10' => 'Ten', 'J' => 'Jack', 'Q' => 'Queen', 'K' => 'King', 
                'A' => 'Ace'}

class Card
  attr_accessor :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def print
    @suit = SUITS_PRINTS["#{suit}"]
    @rank = RANKS_PRINTS["#{rank}"]
    "#{rank} of #{suit}"
  end
end

class Deck
  attr_accessor :deck

  def initialize
    @deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        @deck << Card.new(suit, rank)
      end
    end
    scramble!
  end

  def scramble!
    deck.shuffle!
  end

  def deal!
    deck.pop
  end

  # not needed, I was just testing stuff out
  #def print_deck
  #  @deck.each do |card|
  #    card
  #  end
  #  @deck
  #end
end

class Player
  attr_accessor :name, :hand, :value

  def initialize(name)
    @name = name
    @hand = []
    @value = 0
  end

  def get_dealt(card)
    hand << card
  end

  def print_hand
    @hand_print = "#{name} has:"
    hand.each do |card|
      @hand_print += " |#{card.print}|"
    end
    @hand_print += " for a value of #{calculate_value}."
    @hand_print
  end

  def calculate_value    
    hand.each do |card|
      if card.rank == 'A' # A case
        self.value += 11
      elsif card.rank.to_i == 0 # K, Q, J cases
        self.value += 10
      else
        self.value += card.rank.to_i
      end
    end
    self.value
  end
end

class Human < Player
end

class Dealer < Player  
  #figure out how to make first card invisible/unknown
end

class Blackjack
  attr_accessor :you, :dealer, :deck

  def initialize
    @you = Human.new('Player')
    @dealer = Dealer.new('Dealer')
    @deck = Deck.new
  end

  def start
    puts ""
    puts "Welcome to Blackjack!"
    puts ""
    self.new_deal
  end

  def new_deal
    puts "New hand is being dealt, good luck!"
    you.get_dealt(deck.deal!)
    dealer.get_dealt(deck.deal!)
    you.get_dealt(deck.deal!)
    dealer.get_dealt(deck.deal!)
    puts ""
    puts you.print_hand
    puts dealer.print_hand
  end
  #initialize player and dealer
  #initialize deck
  #
  #deal two cards to each
  #implement logic
end

Blackjack.new.start