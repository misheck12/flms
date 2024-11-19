class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :position
      t.string :profile_picture
      t.integer :goals
      t.integer :assists
      t.integer :clean_sheets
      t.integer :yellow_cards
      t.integer :red_cards
      t.boolean :injury_status
      t.text :injury_details

      t.timestamps
    end
  end
end
