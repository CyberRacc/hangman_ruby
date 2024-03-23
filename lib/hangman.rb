# frozen-string-literal: true

# Hangman class
class Hangman
  def initialize

  end
end

class Word
  attr_reader :word, :word_teaser

  def initialize
    @word = random_word
    @word_teaser = word_teaser
  end

  def create_teaser(word)
    word.split('').each_with_index do |char, index|
      word[index] = '_' if index != 0 && index != word.length - 1
    end
  end

  def random_word
    File.open('/google-10000-english-no-swears.txt', 'r') do |file|
      all_words = file.readlines
      selected_word = all_words.select { |word| word.length >= 5 && word.length <= 12 }
      selected_word.sample
    end
  end
end
