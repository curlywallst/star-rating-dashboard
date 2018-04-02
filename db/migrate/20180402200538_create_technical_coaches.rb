class CreateTechnicalCoaches < ActiveRecord::Migration[5.1]
  def change
    create_table :technical_coaches do |t|
      t.string :slug
      t.string :name

      t.timestamps
    end
  end
end
