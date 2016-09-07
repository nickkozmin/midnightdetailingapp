class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :customer_id
      t.string :email
      t.string :jobber_id
      t.string :detailer
      t.decimal :amount
      t.integer :rating
      t.decimal :tip_percent
      t.string :first_name
      t.string :last_name
      t.decimal :total
      t.string :notes

      t.timestamps null: false
    end
  end
end
