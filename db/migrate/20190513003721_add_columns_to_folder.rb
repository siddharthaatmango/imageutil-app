class AddColumnsToFolder < ActiveRecord::Migration[5.2]
  def change
    add_column :folders, :original_name, :string, default: ""
    add_column :folders, :file_size, :integer, default: 0
    add_column :folders, :mime_type, :string, default: ""
  end
end
