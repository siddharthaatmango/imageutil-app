class AddAttrbutesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deleted_at, :datetime
    add_column :users, :plan, :integer, default: 0
  end
end
