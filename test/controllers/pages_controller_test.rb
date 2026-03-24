require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "홈페이지 로드" do
    get root_path
    assert_response :success
  end

  test "가격 페이지 로드" do
    get pricing_path
    assert_response :success
  end

  test "포트폴리오 페이지 로드" do
    get portfolio_path
    assert_response :success
  end

  test "연락처 페이지 로드" do
    get contact_path
    assert_response :success
  end

  test "개인정보처리방침 페이지 로드" do
    get privacy_path
    assert_response :success
  end

  test "이용약관 페이지 로드" do
    get terms_path
    assert_response :success
  end

  test "견적 문의 전송" do
    post contact_path, params: {
      quote: {
        contact_name: "테스트",
        email: "test@example.com",
        phone: "010-1234-5678",
        message: "테스트 문의입니다",
        nickname: ""
      }
    }
    assert_response :redirect
    assert_redirected_to contact_path
  end

  test "스팸 견적 차단 (허니팟)" do
    post contact_path, params: {
      quote: {
        contact_name: "Spam",
        email: "spam@test.com",
        phone: "010-0000-0000",
        message: "Buy now!",
        nickname: "bot filled this"
      }
    }
    assert_response :redirect
    assert_redirected_to contact_path
  end

  test "스팸 견적은 DB에 저장하지 않음" do
    assert_no_difference "Quote.count" do
      post contact_path, params: {
        quote: {
          contact_name: "Bot",
          email: "bot@test.com",
          phone: "010-0000-0000",
          message: "Spam message",
          nickname: "spam_value"
        }
      }
    end
  end

  test "헬스체크 엔드포인트" do
    get rails_health_check_path
    assert_response :success
  end
end
