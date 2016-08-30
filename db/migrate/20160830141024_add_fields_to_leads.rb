class AddFieldsToLeads < ActiveRecord::Migration
  def change
  	add_column :leads, :service_type, :string
  	add_column :leads, :customer_id, :string
  	add_column :leads, :funnel_step, :integer 
  end
end
