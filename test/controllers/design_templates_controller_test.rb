require "test_helper"

class DesignTemplatesControllerTest < ActionDispatch::IntegrationTest
  test "템플릿 목록 페이지 로드" do
    get design_templates_path
    assert_response :success
  end

  test "템플릿 제목 검색" do
    get design_templates_path, params: { query: "모던" }
    assert_response :success
  end

  test "존재하지 않는 검색어" do
    get design_templates_path, params: { query: "없는검색어xyz" }
    assert_response :success
  end

  test "카테고리 필터링" do
    get design_templates_path, params: { category: "business" }
    assert_response :success
  end

  test "전체 카테고리 필터 (all)" do
    get design_templates_path, params: { category: "all" }
    assert_response :success
  end

  test "정렬 - 인기순" do
    get design_templates_path, params: { sort: "popular" }
    assert_response :success
  end

  test "정렬 - 최신순" do
    get design_templates_path, params: { sort: "latest" }
    assert_response :success
  end

  test "페이지네이션" do
    get design_templates_path, params: { page: 1 }
    assert_response :success
  end

  test "카테고리 + 검색어 조합 필터" do
    get design_templates_path, params: { category: "business", query: "모던" }
    assert_response :success
  end
end
