class AddUserToTeams < ActiveRecord::Migration[7.0]
  def change
    add_reference :teams, :user, null: false, foreign_key: true
  end
end
