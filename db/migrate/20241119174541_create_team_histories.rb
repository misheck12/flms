class CreateTeamHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :team_histories do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :season_year
      t.integer :wins
      t.integer :draws
      t.integer :losses
      t.integer :goals_scored
      t.integer :goals_conceded
      t.integer :goal_difference

      t.timestamps
    end
  end
end
