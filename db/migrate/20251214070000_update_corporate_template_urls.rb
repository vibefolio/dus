class UpdateCorporateTemplateUrls < ActiveRecord::Migration[8.1]
  class DesignTemplate < ActiveRecord::Base; end

  def up
    novus = DesignTemplate.find_by(title: "Novus")
    novus&.update(preview_url: "/templates/startup", category: "corporate")

    rent = DesignTemplate.find_by(title: "Rent-All")
    rent&.update(preview_url: "/templates/rental", category: "corporate")

    invest = DesignTemplate.find_by(title: "Invest Future")
    invest&.update(preview_url: "/templates/finance", category: "corporate")
  end
end
