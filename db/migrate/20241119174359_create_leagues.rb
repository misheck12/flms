class CreateLeagues < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.text :rules

      t.timestamps
    end
  end
end
