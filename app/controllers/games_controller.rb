class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:word].upcase
    @letters = params[:letters]

    @score = if included?(@guess, @letters)
               if english_word?(@guess)
                 "Congratulations! #{@guess} is a valid English word!"
               else
                 "Sorry but #{@guess} doest not seem to be a valid English word..."
               end
             else
               "Sorry but #{@guess} cant be build out of #{@letters}"
             end
  end

  private

  def included?(guess, letters)
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end

  def english_word?(guess)
    response = URI.parse("https://dictionary.lewagon.com/#{guess}")
    word = JSON.parse(response.read)
    word['found']
  end
end
