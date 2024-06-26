# frozen-string-literal: true

require 'json'

# Contains helper methods
module Helpers
  def self.clear_screen
    system('clear') || system('cls')
  end

  def self.create_save_file(game)
    File.write('save.json', game.to_json)
  end
end

# Contains the main game logic
class Hangman
  include Helpers

  def initialize
    @lives = 7
    @user_interaction = UserInteraction.new
    @word = Word.new
    load_game if File.exist?('save.json') && @user_interaction.load_game?
    start_game if @user_interaction.start_game?
  end

  def start_game
    puts 'Welcome to Hangman!'
    puts 'Here is your word:'
    puts @word.word_teaser
    puts "The word is #{@word.word.length} characters long."
    play_game
  end

  def play_game
    loop do
      guess = @user_interaction.guess_input
      check_guess(guess)
      display_teaser
      break if check_win || @lives.zero?

      save_game if guess == 'save' && @user_interaction.save_game?
    end
    check_win == true ? game_won : game_over
  end

  def game_won
    puts 'Congratulations! You guessed the word correctly'
    File.delete('save.json') if File.exist?('save.json')
    @user_interaction.play_again
  end

  def game_over
    puts 'Game over!'
    puts "The word was: #{@word.word}"
    @user_interaction.play_again
  end

  def check_win
    @word.word == @word.word_teaser.gsub(' ', '')
  end

  def check_guess(guess)
    puts "You guessed: #{guess}" unless guess == 'save'
    if @word.word.include?(guess)
      puts 'Good guess!'
      update_teaser(guess)
    else
      puts 'Sorry, that letter is not in the word' unless guess == 'save'
      decrease_life unless guess == 'save'
    end
  end

  def display_teaser
    puts @word.word_teaser
  end

  def update_teaser(guess)
    new_teaser = @word.word_teaser.split

    new_teaser.each_with_index do |_letter, index|
      new_teaser[index] = guess if @word.word[index] == guess
    end

    @word.word_teaser = new_teaser.join(' ')
  end

  def decrease_life
    @lives -= 1
    puts "You have #{@lives} lives left"
  end

  def save_game
    game_state = {
      word: @word.word,
      word_teaser: @word.word_teaser,
      lives: @lives
    }
    Helpers.create_save_file(game_state)
    puts 'Game saved!'
  end

  def load_game
    game_state = JSON.parse(File.read('save.json'))
    @word.word = game_state['word']
    @word.word_teaser = game_state['word_teaser']
    @lives = game_state['lives']
    puts 'Game loaded!'
  end
end

# Contains logic for getting user input
class UserInteraction
  def play_again
    print 'Do you want to play again? (yes/no): '
    if gets.chomp.downcase == 'yes'
      Hangman.new
    else
      puts 'Thanks for playing!'
      exit
    end
  end

  def start_game?
    print 'Play Hangman? (yes/no): '
    response = gets.chomp.downcase
    until %w[yes no].include?(response)
      print 'Please enter "yes" or "no": '
      response = gets.chomp.downcase
    end
    response == 'yes'
  end

  def guess_input
    print 'Type a letter to guess the word or type "exit" to quit the game: '
    guess = gets.chomp.downcase
    until guess_valid?(guess)
      puts 'Please enter a single letter'
      print 'Type a letter to guess the word or type "exit" to quit the game: '
      guess = gets.chomp.downcase
    end
    guess
  end

  def guess_valid?(guess)
    if guess == 'exit'
      puts 'Thanks for playing!'
      exit
    elsif guess == 'save'
      true
    elsif guess.length > 1 || guess.match?(/[^a-zA-Z]/)
      false
    else
      true
    end
  end

  def save_game?
    print 'Do you want to save the game? (yes/no): '
    response = gets.chomp.downcase
    until %w[yes no].include?(response)
      print 'Please enter "yes" or "no": '
      response = gets.chomp.downcase
    end
    response == 'yes'
  end

  def load_game?
    print 'Do you want to load the game? (yes/no): '
    response = gets.chomp.downcase
    until %w[yes no].include?(response)
      print 'Please enter "yes" or "no": '
      response = gets.chomp.downcase
    end
    response == 'yes'
  end
end

# Holds the logic for creating a word based on a text file.
class Word
  attr_accessor :word, :word_teaser

  def initialize
    @word = random_word
    @word_teaser = create_teaser(@word)
  end

  def create_teaser(word)
    word.chars.map { '_' }.join(' ')
  end

  def random_word
    file_path = File.join(__dir__, '..', 'google-10000-english-no-swears.txt')
    File.open(file_path, 'r') do |file|
      all_words = file.readlines.map(&:chomp)
      selected_word = all_words.select { |word| word.length >= 5 && word.length <= 12 }
      selected_word.sample
    end
  end
end

Hangman.new
