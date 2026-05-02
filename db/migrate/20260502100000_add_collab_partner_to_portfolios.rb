class AddCollabPartnerToPortfolios < ActiveRecord::Migration[8.0]
  def change
    add_column :portfolios, :collab_partner, :string
    add_column :portfolios, :sub_category, :string
  end
end
