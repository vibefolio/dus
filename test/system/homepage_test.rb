require "application_system_test_case"

class HomepageTest < ApplicationSystemTestCase
  test "홈페이지 정상 렌더링" do
    visit root_path
    assert_selector "body"
  end
end
