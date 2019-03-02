class AddIsSupportToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_support, :boolean, default: false
  end
end
