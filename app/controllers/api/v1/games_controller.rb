require 'rest-client'

class Api::V1::GamesController < ApplicationController

    # def index
    #    @games = Game.all
    #    render json: @games
    # end

    # def show
    #     @game = Game.find(params[:game_id])
    #     render json: @game
    # end

    # eventually change this index method to a create method...just using index for starters
    def index
        category_number = params[]
        difficulty = params[]

        # TODO - take in the form from frontEnd and use those values to request from API
        results = RestClient.get('https://opentdb.com/api.php?amount=10&category=11&difficulty=easy&type=multiple')
        questions = JSON.parse(results)
        # TODO - then create new game...map over questions["results"] and find_or_create_by for each question object...ALSO, eventually associate the current user to this @game instance
        @game = Game.create()

        new_questions = questions["results"].map do |questionObj|
            Question.where(question: questionObj["question"]).first_or_create do |question| 
                question.answer = questionObj["correct_answer"]
                question.incorrect_answers = (questionObj["incorrect_answers"])
            end
        end
        # byebug
        new_questions.each do |question|
            GameQuestion.create(game_id: @game.id, question_id: question.id)
        end

        
        render json: @game

    end


    def update
        # receive the finished game data and update the game with the score
    end



end
