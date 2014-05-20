
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
    suit_print = SUITS_PRINTS["#{suit}"]
    rank_print = RANKS_PRINTS["#{rank}"]
    "#{rank_print} of #{suit_print}"
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
    deck.shuffle!
  end

  def deal!
    deck.pop
  end
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
    @hand_print = "#{name} has"

    hand.each do |card|
      @hand_print += " |#{card.print}|"
    end
    @hand_print += " for a value of #{self.value}."

    @hand_print
  end

  def calculate_value
    self.value = 0

    hand.each do |card|
      if card.rank == 'A' # A case
        self.value += 11
      elsif card.rank.to_i == 0 # K, Q, J cases
        self.value += 10
      else
        self.value += card.rank.to_i
      end
    end

    hand.select{ |card| card.rank == 'A' }.count.times do
      self.value -= 10 if self.value > 21
    end

    self.value
  end

  def busted?
    if self.value > 21
      true
    end
  end

  def blackjack?
    if self.value == 21
      true
    end
  end
end

class Human < Player
end

class Dealer < Player  
  # Dealer specific: one card hidden
  def print_with_hidden
    @hand_print = "#{name} has"

    hand.each_with_index do |card, index|
      if index == 0
        @hand_print += " |Hidden Card|"
      else
        @hand_print += " |#{card.print}|"
      end
    end
    @hand_print += " for a value of #{self.value}."

    @hand_print
  end

  def calculate_with_hidden
    self.value = 0

    hand.each_with_index do |card, index|
      if index == 0
        self.value
      else
        if card.rank == 'A' # A case
          self.value += 11
        elsif card.rank.to_i == 0 # K, Q, J cases
          self.value += 10
        else
          self.value += card.rank.to_i
        end
      end
    end

    self.value
  end
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
    player_turn
    dealer_turn
    puts ""
    puts "Final hands: " + you.print_hand
    puts "Final hands: " + dealer.print_hand
    puts ""
    determine_winner
    play_again?
  end

  def new_deal
    puts "New hand is being dealt, good luck!"
    you.get_dealt(deck.deal!)
    dealer.get_dealt(deck.deal!)
    you.get_dealt(deck.deal!)
    dealer.get_dealt(deck.deal!)
    puts ""
    you.calculate_value
    dealer.calculate_with_hidden
    puts you.print_hand
    puts dealer.print_with_hidden
    dealer.calculate_value
    puts ""
  end

  def player_turn
    while you.value < 21
      puts "Hit or Stand? Enter 'h' for hit, 's' for stand."
      action = gets.chomp
      if action == 'h'
        you.get_dealt(deck.deal!)
        you.calculate_value
        puts ""
        puts "You decided to hit."
      elsif action == 's'
        puts ""
        puts "You decided to stand."        
        break
      else
        puts "#{action} is not a valid action. Enter 'h' for hit, 's' for stand."
      end
      puts you.print_hand
    end
  end

  def dealer_turn
    puts ""
    puts dealer.print_hand
    while dealer.value < 17
      dealer.get_dealt(deck.deal!)
      dealer.calculate_value
      puts ""
      puts "Dealer hits!"
      puts dealer.print_hand
    end
  end

  def determine_winner
    if you.blackjack?
      puts "You hit blackjack! You win!"
    elsif you.busted?
      puts "Sorry, you went bust. Dealer wins."
    elsif dealer.blackjack?
      puts "Dealer hit blackjack. Dealer wins."
    elsif dealer.busted?
      puts "Dealer went bust. You win!"
    elsif you.value > dealer.value
      puts "Congratulations, you win!"
    elsif you.value < dealer.value
      puts "Sorry, this time Dealer wins."
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    puts ""
    puts "Do you want to play again? Enter 'y' if you do."
    answer = gets.chomp
    if answer == 'y'
      initialize
      self.start
    else
      puts ""
      puts "See you next time!"
    end
  end
end

Blackjack.new.start
