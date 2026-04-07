class AddSourceToQuotes < ActiveRecord::Migration[8.1]
  def change
    add_column :quotes, :source, :string, default: "website"
    add_index :quotes, :source
  end
end
