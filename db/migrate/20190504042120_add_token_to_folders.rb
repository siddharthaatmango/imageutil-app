class AddTokenToFolders < ActiveRecord::Migration[5.2]
  def change
    add_column :folders, :upload_token, :string, index: { unique: true }
  end
end
