require "test_helper"

class DesignTemplateTest < ActiveSupport::TestCase
  # === 밸리데이션 ===

  test "유효한 디자인 템플릿 생성" do
    template = DesignTemplate.new(title: "새 템플릿", category: "business", price: 50000)
    assert template.valid?
  end

  test "title 필수값 확인" do
    template = DesignTemplate.new(category: "business")
    assert_not template.valid?
    assert_includes template.errors[:title], "can't be blank"
  end

  # === pc_thumbnail_url ===

  test "pc_thumbnail_url image_url이 있으면 반환" do
    template = design_templates(:one)
    assert_equal "https://example.com/template1.png", template.pc_thumbnail_url
  end

  test "pc_thumbnail_url image_url 없으면 기본 이미지 반환" do
    template = design_templates(:two)
    # image_url이 빈 문자열이므로 fallback
    assert_equal "/images/templates/portfolio_gallery.png", template.pc_thumbnail_url
  end

  test "pc_thumbnail_url 기본 이미지 경로 확인" do
    template = DesignTemplate.new(title: "테스트")
    expected = "/images/templates/portfolio_gallery.png"
    assert_equal expected, template.pc_thumbnail_url
  end

  # === mobile_thumbnail_url ===

  test "mobile_thumbnail_url mobile_image_url이 있으면 반환" do
    template = design_templates(:three)
    assert_equal "https://example.com/template3_m.png", template.mobile_thumbnail_url
  end

  test "mobile_thumbnail_url 없으면 pc_thumbnail_url로 대체" do
    template = design_templates(:one)
    # mobile_image_url이 없으므로 pc_thumbnail_url로 폴백
    assert_equal template.pc_thumbnail_url, template.mobile_thumbnail_url
  end

  # === 이미지 소스 타입 ===

  test "pc_image_source_type URL이 있을 때 :url" do
    template = design_templates(:one)
    assert_equal :url, template.pc_image_source_type
  end

  test "pc_image_source_type 아무것도 없을 때 :none" do
    template = DesignTemplate.new(title: "빈 템플릿")
    assert_equal :none, template.pc_image_source_type
  end

  test "mobile_image_source_type mobile_image_url이 있을 때 :url" do
    template = design_templates(:three)
    assert_equal :url, template.mobile_image_source_type
  end

  test "mobile_image_source_type 아무것도 없을 때 :none" do
    template = DesignTemplate.new(title: "빈 템플릿")
    assert_equal :none, template.mobile_image_source_type
  end

  # === all_static ===

  test "all_static YAML 파일에서 정적 데이터 로드" do
    templates = DesignTemplate.all_static
    # templates.yml이 존재하면 결과 반환, 없으면 빈 배열
    assert_kind_of Array, templates
  end

  test "all_static 정적 템플릿 음수 ID 사용" do
    templates = DesignTemplate.all_static
    if templates.any?
      templates.each do |t|
        assert t.id.negative?, "정적 템플릿의 ID는 음수여야 합니다"
      end
    end
  end

  test "all_static 정적 템플릿에 pc_thumbnail_url 존재" do
    templates = DesignTemplate.all_static
    if templates.any?
      templates.each do |t|
        assert_respond_to t, :pc_thumbnail_url
        assert_not_nil t.pc_thumbnail_url
      end
    end
  end

  # === all_combined ===

  test "all_combined DB와 정적 데이터 합침" do
    combined = DesignTemplate.all_combined
    assert_kind_of Array, combined
    # DB에 3개 fixture + 정적 데이터
    assert combined.length >= 3
  end

  # === Active Storage 첨부파일 ===

  test "pc_image 첨부 가능" do
    template = design_templates(:one)
    assert_respond_to template, :pc_image
  end

  test "mobile_image 첨부 가능" do
    template = design_templates(:one)
    assert_respond_to template, :mobile_image
  end
end
