class Question < ApplicationRecord
    # belongs_to :game
    has_many :games, through: :game_questions
    has_many :users, through: :games
end
