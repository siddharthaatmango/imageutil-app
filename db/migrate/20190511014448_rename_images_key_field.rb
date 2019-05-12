class RenameImagesKeyField < ActiveRecord::Migration[5.2]
  def change
    rename_column :images, :key, :store_key
  end
end
