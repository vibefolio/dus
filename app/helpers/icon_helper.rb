# 3D 아이콘 렌더링. 이름 → config/icons.yml → app/assets/images/icons/*.png
#
# 20px 안팎의 기능성 글리프(chevron·close·search 등)에는 쓰지 않는다 —
# 3D 아이콘은 작은 크기에서 뭉개진다. 크기 기준은 config/icons.yml 머리말 참조.
module IconHelper
  # 이름 없는 아이콘을 조용히 넘기지 않는다.
  # 개발/테스트에서는 즉시 터뜨리고, 프로덕션에서만 로그를 남기고 화면을 지킨다.
  def icon_3d(name, size: 56, alt: nil, **options)
    entry = Icons.lookup(name)

    unless entry
      raise Icons::MissingIcon, "config/icons.yml 에 '#{name}' 없음" unless Rails.env.production?

      Rails.logger.error("[icon_3d] 매니페스트에 없는 아이콘: #{name}")
      return "".html_safe
    end

    image_tag "icons/#{entry['file']}",
              width: size,
              height: size,
              loading: "lazy",
              decoding: "async",
              alt: alt || entry["label"] || "",
              **options
  end

  # 연한 그린 타일 위에 아이콘을 얹은 블록. 피처 카드·KPI 카드용.
  #
  # 3D 아이콘은 자기 색을 가지고 있어서 진한 그라디언트 타일 위에 올리면 탁해진다.
  # 그래서 배경을 아주 연하게 깔고 아이콘이 주인공이 되게 한다.
  def icon_3d_tile(name, size: 40, tile: 68, alt: nil, **options)
    tag.span class: "icon-tile", style: "width:#{tile}px;height:#{tile}px;" do
      icon_3d(name, size: size, alt: alt, **options)
    end
  end

  # DesignTemplate.category 키 → 아이콘 + 한글 라벨
  def category_icon(key, size: 20, **options)
    entry = Icons.category(key)
    return "".html_safe unless entry

    image_tag "icons/#{entry['icon']}",
              width: size, height: size,
              loading: "lazy", decoding: "async",
              alt: entry["label"],
              **options
  end

  def category_label(key)
    Icons.category_label(key)
  end
end
