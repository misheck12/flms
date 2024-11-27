class AddDetailsToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :city, :string
    add_column :teams, :stadium, :string
    add_column :teams, :foundation_year, :integer
    add_column :teams, :president, :string
    add_column :teams, :manager, :string
  end
end
