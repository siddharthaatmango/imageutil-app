class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.string :key, index: { unique: true }
      t.string :origin
      t.string :origin_path
      t.string :transformation
      t.boolean :is_smart
      t.string :cdn_path
      t.integer :file_size, default: 0

      t.timestamps
    end
    add_index :images, [:origin, :origin_path, :transformation, :is_smart], unique: true, name: "index_uniq_path"
  end
end
