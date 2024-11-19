class AddDetailsToLeagues < ActiveRecord::Migration[7.0]
  def change
    add_column :leagues, :name, :string
    add_column :leagues, :description, :text
    add_column :leagues, :start_date, :date
    add_column :leagues, :end_date, :date
    add_column :leagues, :rules, :text
  end
end
