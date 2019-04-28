class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.references :folder, foreign_key: true
      t.boolean :is_file
      t.string :name
      t.string :path, index: { unique: true }

      t.timestamps
    end
    add_index :folders, [:user_id, :project_id, :path], unique: true, name: "index_uniq_key"
  end
end
