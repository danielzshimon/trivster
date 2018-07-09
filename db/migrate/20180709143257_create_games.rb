class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :score
      t.integer :user_id
      # t.string :questions

      t.timestamps
    end
  end
end
