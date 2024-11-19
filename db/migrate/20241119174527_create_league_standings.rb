class CreateLeagueStandings < ActiveRecord::Migration[7.0]
  def change
    create_table :league_standings do |t|
      t.references :league, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :position
      t.integer :points
      t.integer :goal_difference

      t.timestamps
    end
  end
end
