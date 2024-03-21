# frozen-string-literal: true

# Key words:
# word_teaser - the word with the letters that have been guessed correctly
# word - the word that the player is trying to guess
# lives - the number of lives the player has left
# guess - the letter that the player has guessed

require 'rubocop'

# Hangman class
class Hangman
  def initialize
    @user_interaction = UserInteraction.new
    @word = select_word.split('')
    @lives = 7
    @word_teaser = ''
    @word.length.times do
      @word_teaser += '_ '
    end
    @player = Player.new(@user_interaction.player_name, @lives)
  end

  def play_game
    puts 'Welcome to Hangman!'
    puts 'Here is your word:'
    print_teaser
  end

  def words_dictionary
    File.open('google-10000-english-no-swears.txt', 'r') do |file|
      file.readlines.map(&:strip)
    end
  end

  def select_word
    possible_words = words_dictionary.select { |word| word.length >= 5 && word.length <= 12 }

    # Select a random word from the possible words
    possible_words.sample
  end

  def print_teaser(last_guess = nil)
    update_teaser(last_guess) unless last_guess.nil?
    puts @word_teaser
  end

  def display_progress
    print_teaser if @word.include?('_')
  end
end

class UserInteraction
  def guess_input
    print 'Enter a letter: '
    gets.chomp
  end

  def player_name
    print 'Enter your name: '
    gets.chomp
  end

  def play_again?
    print 'Do you want to play again? (yes/no): '
    gets.chomp.downcase == 'yes'
  end

  def display_lives(lives)
    puts "You have #{lives} lives left."
  end
end

class Player
  attr_reader :name, :lives

  def initialize(name, lives)
    @name = name
    @lives = lives
  end
end

Hangman.new
