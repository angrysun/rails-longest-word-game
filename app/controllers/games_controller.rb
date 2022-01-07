require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]
    @letters = []
    10.times do
      @letters << alphabet[rand(26)]
    end
  end

  def score
    @user_input = params[:word].upcase
    @letters = params[:letters]
    @token = params[:authenticity_token]
    if @token
      url = "https://wagon-dictionary.herokuapp.com/#{@user_input}"
      html = URI.open(url).read
      word_hash = JSON.parse(html)
      @message = ''
      @user_input = @user_input.split('')

      @user_input.each do |letter|
        unless @letters.include?(letter)
          return @message = "Sorry but #{@user_input.join} can't be built out of the grid"
        end
      end
      if word_hash['found']
        @message = "Congratulations! #{@user_input.join} is a valid English word"
      else
        @message = "Sorry, #{@user_input.join} is not a valid English word"
      end
    else
      'Access denied'
    end
  end

  private
end
