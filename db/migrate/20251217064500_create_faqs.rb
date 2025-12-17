class CreateFaqs < ActiveRecord::Migration[7.0]
  def change
    create_table :faqs do |t|
      t.text :question, null: false
      t.text :answer, null: false
      t.integer :position, default: 0
      t.boolean :published, default: true

      t.timestamps
    end

    add_index :faqs, :position
    add_index :faqs, :published
  end
end
