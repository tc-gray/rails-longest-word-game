require 'open-uri'

class GamesController < ApplicationController
  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid_array = []
    grid_size.times { grid_array << ('A'..'Z').to_a.sample }
    grid_array
  end

  def new
    @letters = generate_grid(10)
  end

  def valid_letters?(attempt, grid)
    attempt.upcase.chars.each do |letter|
      return false unless grid.include?(letter)

      grid.delete_at(grid.index(letter))
    end
  end

  def valid_word?(attempt)
    json_string = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    word_hash = JSON.parse(json_string)
    word_hash['found'] == true
  end

  def check_word(guess, grid)
    if valid_letters?(guess, grid)
      if valid_word?(guess)
        'congrats'
      else
        'not a word'
      end
    else
      'no'
    end
  end

  def score
    @guess = params[:guess]
    @grid = params[:letters].split
    @valid = check_word(@guess, @grid)
  end
end
