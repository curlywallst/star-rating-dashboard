class CreateTechnicalCoachRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :technical_coach_ratings do |t|
      t.integer :technical_coach_id
      t.integer :rating_id

      t.timestamps
    end
  end
end
