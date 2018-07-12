require 'rest-client'

class Api::V1::GamesController < ApplicationController

    def index
       @games = Game.all
       render json: @games
    end

    # def show
    #     @game = Game.find(params[:game_id])
    #     render json: @game
    # end

    def create

        category = params[:category]
        difficulty = params[:difficulty]
        # byebug
        if category == 1  
            # https://opentdb.com/api.php?amount=10&difficulty=easy
            results = RestClient.get('https://opentdb.com/api.php?amount=10&difficulty='+ difficulty + '&type=multiple')
            questions = JSON.parse(results)
        else 
            results = RestClient.get('https://opentdb.com/api.php?amount=10&category='+ category.to_s + '&difficulty='+ difficulty + '&type=multiple')
            questions = JSON.parse(results)
        end

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

        new_questions.push({game_id: @game.id})

        render json: new_questions

    end


    def update
        # receive the finished game data and update the game with the score
    end

# <ActionController::Parameters {"category"=>12, "difficulty"=>"medium", "controller"=>"api/v1/games", "action"=>"create", "game"=>{}} permitted: false>

end
