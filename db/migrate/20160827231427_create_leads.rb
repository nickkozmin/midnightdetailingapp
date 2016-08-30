class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :address
      t.string :first_name
      t.string :last_name
      t.string :car_type
      t.string :date_request
      t.string :time_request
      t.string :phone_number
      t.string :email
      t.string :address_line_2
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country
      t.string :condo
      t.string :license_plate
      t.string :frequency

      t.timestamps null: false
    end
  end
end
