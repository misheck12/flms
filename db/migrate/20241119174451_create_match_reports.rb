class CreateMatchReports < ActiveRecord::Migration[7.0]
  def change
    create_table :match_reports do |t|
      t.references :match, null: false, foreign_key: true
      t.references :referee, null: false, foreign_key: true
      t.text :report_details
      t.json :goal_scorers
      t.json :cards
      t.text :notable_incidents

      t.timestamps
    end
  end
end
