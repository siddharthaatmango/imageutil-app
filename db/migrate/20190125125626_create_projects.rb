class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :uuid, index:  { unique: true }, limit: 255
      t.string :fqdn, index:  { unique: true }, limit: 255
      t.string :base_path, limit: 255, default: ''
      t.string :protocol, limit: 5, default: 'https'
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
