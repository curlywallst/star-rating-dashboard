class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.integer :user_id
      t.integer :technical_coach_lead_id
      t.integer :technical_coach_id
      t.integer :admin_id
      t.timestamps
    end
  end
end
