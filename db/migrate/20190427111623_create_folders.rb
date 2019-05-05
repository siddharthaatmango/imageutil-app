class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.references :folder, foreign_key: true
      t.boolean :is_file
      t.string :name
      t.string :path, index: { unique: true }
      t.string :upload_token, index: { unique: true }
      t.timestamps
    end
  end
end
