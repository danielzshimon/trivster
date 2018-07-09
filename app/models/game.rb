class Game < ApplicationRecord
    belongs_to :user, optional: true
    has_many :game_questions
    has_many :questions, through: :game_questions
end
