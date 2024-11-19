class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :league, null: false, foreign_key: true
      t.references :home_team, null: false, foreign_key: true
      t.references :away_team, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.string :venue
      t.integer :home_team_score
      t.integer :away_team_score
      t.string :status

      t.timestamps
    end
  end
end
