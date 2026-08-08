xml.instruct!
xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
  # Static Pages
  xml.url do
    xml.loc @base_url
    xml.changefreq "daily"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{@base_url}/design_templates"
    xml.changefreq "weekly"
    xml.priority 0.8
  end

  xml.url do
    xml.loc "#{@base_url}/portfolio"
    xml.changefreq "weekly"
    xml.priority 0.8
  end
  
  xml.url do
    xml.loc "#{@base_url}/pricing"
    xml.changefreq "monthly"
    xml.priority 0.8
  end

  xml.url do
    xml.loc "#{@base_url}/contact"
    xml.changefreq "monthly"
    xml.priority 0.5
  end

  xml.url do
    xml.loc "#{@base_url}/majortax"
    xml.changefreq "monthly"
    xml.priority 0.6
  end

  # 템플릿 데모 페이지 — 업종별 롱테일 검색 유입 경로다.
  # robots.txt 에서 /templates/* 를 열었으므로(2026-08-08) 여기서도 색인 대상으로 등재한다.
  Array(@templates).each do |template|
    url = template.respond_to?(:preview_url) ? template.preview_url : nil
    next if url.blank? || !url.to_s.start_with?("/templates/")

    xml.url do
      xml.loc "#{@base_url}#{url}"
      xml.changefreq "monthly"
      xml.priority 0.6
    end
  end

  # Dynamic Pages - Portfolios (No detail page yet, but preparing)
  # @portfolios.each do |portfolio|
  #   xml.url do
  #     xml.loc "#{@base_url}/portfolio/#{portfolio.id}"
  #     xml.lastmod portfolio.updated_at.strftime("%Y-%m-%d")
  #     xml.changefreq "monthly"
  #     xml.priority 0.6
  #   end
  # end
end
