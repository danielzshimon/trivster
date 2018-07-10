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

    # eventually change this index method to a create method...just using index for starters
    def create

        category = params[:category]
        difficulty = params[:difficulty]
        # Todo - take in the form from frontEnd and use those values to request from API
        results = RestClient.get('https://opentdb.com/api.php?amount=10&category='+ category.to_s + '&difficulty='+ difficulty + '&type=multiple')
        questions = JSON.parse(results)
        # Todo - then create new game...map over questions["results"] and find_or_create_by for each question object...ALSO, eventually associate the current user to this @game instance
        @game = Game.create()

        # questions["results"].each do |question|
        #     Question.create(question: question["question"], answer: question["correct_answer"], incorrect_answers: question["incorrect_answers"])
        # end

        # questions["results"].each do |questionObj|
        #     Question.where(question: questionObj["question"]).first_or_create do |question|
        #         question.answer = questionObj["correct_answer"]
        #         question.incorrect_answers = (questionObj["incorrect_answers"])
        #     end
        # end
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

        # We're adding each question that exists to the new game being made...last game has same number of questions as total number of questions
        # Question.all.each do |question|
        #     GameQuestion.create(game_id: @game.id, question_id: question.id)
        # end



        render json: @game

    end


    def update
        # receive the finished game data and update the game with the score
    end

# <ActionController::Parameters {"category"=>12, "difficulty"=>"medium", "controller"=>"api/v1/games", "action"=>"create", "game"=>{}} permitted: false>

end
