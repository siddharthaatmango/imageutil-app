class CreateAnalytics < ActiveRecord::Migration[5.2]
  def change
    create_table :analytics do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.integer :uniq_request, default: 0
      t.integer :total_request, default: 0
      t.integer :total_bytes, default: 0
      t.bigint :last_image_id

      t.timestamps
    end
  end
end
