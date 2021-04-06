class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)].upcase }
  end

  def score
    @answer = params[:answer]
    @answer_arr = @answer.split(" ")
    @letters = params[:letters].split(" ")
    all_letters = true
    @answer_arr.each do |letter|
      all_letters = false unless @letters[letter]
    end
    raise
  end
end
