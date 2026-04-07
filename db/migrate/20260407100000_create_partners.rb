class CreatePartners < ActiveRecord::Migration[8.1]
  def change
    create_table :partners do |t|
      t.string :name, null: false
      t.string :partner_type, null: false, default: "tax"  # tax / legal / design
      t.string :email, null: false
      t.string :phone
      t.string :license_number
      t.string :company_name
      t.text :bio
      t.string :website_url
      t.boolean :active, default: true
      t.integer :agency_id
      t.integer :lead_count, default: 0

      t.timestamps
    end

    add_index :partners, :email, unique: true
    add_index :partners, :partner_type
    add_index :partners, :agency_id
  end
end
