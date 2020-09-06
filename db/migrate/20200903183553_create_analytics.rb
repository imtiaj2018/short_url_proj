class CreateAnalytics < ActiveRecord::Migration[5.2]
	def change
		create_table :analytics do |t|
			t.integer :slug_id
			t.string :ip_address
			t.string :country_name
			t.timestamps
		end
	end
end
