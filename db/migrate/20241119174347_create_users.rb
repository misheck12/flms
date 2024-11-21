class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"      t.string :role

      t.timestamps
    end
  end
end
