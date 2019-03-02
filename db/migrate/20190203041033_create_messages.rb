class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.references :message, foreign_key: true
      t.references :project, foreign_key: true
      t.string :status
      t.string :priority, default: 'Low'
      t.string :subject
      t.text :body
      t.boolean :support_call, index: true
      t.boolean :user_call, index: true
      
      t.timestamps
    end
  end
end
