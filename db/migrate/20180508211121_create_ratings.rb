class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.integer :stars
      t.text :comment
      t.string :rating_type
      t.datetime :date
      t.string :landing_id

      t.timestamps
    end
  end
end
