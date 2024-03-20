# frozen-string-literal: true

# Hangman class
class Hangman
  def initialize
    @word = select_word.split('')
    @lives = 7
    @word_teaser = ''
    @word.length.times do
      @word_teaser += '_ '
    end
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
    if @word.include?('_')
      print_teaser
    else
      puts 'Congratulations! You have won!'
    end
  end


end

class UserInteraction
  def initialize

Hangman.new
