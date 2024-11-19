class CreateReferees < ActiveRecord::Migration[7.0]
  def change
    create_table :referees do |t|
      t.references :user, null: false, foreign_key: true
      t.json :availability
      t.json :claimed_matches

      t.timestamps
    end
  end
end
