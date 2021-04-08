require 'open-uri'
require 'json'
require 'date'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)].upcase }
    @current_score = get_historical_score()
  end

  def score
    @answer = params[:answer]
    answer_arr = @answer.split(" ")
    @letters = params[:letters].split(" ")
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    json_answer = open(url).read
    answer = JSON.parse(json_answer)
    previous_score = get_historical_score()
    
    if letters_overused?(@answer, @letters) || !are_letters_included?(@answer, @letters)
      @game_result = build_result(0)
      @game_result = build_result(0)
    elsif answer["found"] == false
      @game_result = build_result(0, "the given word is not an english word") 
    else
      @game_result = build_result(answer["length"], "well done")
    end
    store_in_session(@game_result[:score] + previous_score.to_i)
    @current_score = get_historical_score()
    
  end

  def store_in_session(score)
    cookies[:score] = score
  end

  def get_historical_score 
    score = cookies[:score]
    if score == nil 
      return 0
    else 
      return score
    end

  end

  def build_result(score, message = "the given word uses letters that are not in the grid")
    result = {
      score: score,
      message: message
    }
    
    return result
  end
  
  def are_letters_included?(word, letters)
    word_arr = word.upcase.split("")
    word_arr.each { |letter| return false unless letters.include?(letter) }
    
    return true
  end
  
  def letters_overused?(word, letters)
    word_arr = word.upcase.split("")
    word_arr.each { |letter| return true if word_arr.count(letter) > letters.count(letter) }
    return false
  end
end
