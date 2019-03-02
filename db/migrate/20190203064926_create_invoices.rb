class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.references :user, foreign_key: true
      t.string :status
      t.string :subject
      t.text :body
      t.datetime :duedate

      t.timestamps
    end
  end
end
