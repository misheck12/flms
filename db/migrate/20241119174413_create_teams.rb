class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :league, null: false, foreign_key: true
      t.string :name
      t.string :logo
      t.text :bio
      t.string :contact_email
      t.string :contact_phone
      t.integer :points
      t.integer :wins
      t.integer :draws
      t.integer :losses
      t.integer :goals_scored
      t.integer :goals_conceded
      t.integer :goal_difference
      t.integer :matches_played

      t.timestamps
    end
  end
end
