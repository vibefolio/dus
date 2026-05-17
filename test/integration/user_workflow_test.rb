require "test_helper"

# E2E 통합 테스트 — 접속 → 로그인 → 탐색 → 장바구니 → 견적 → 주문 → 마이페이지 → 로그아웃
class UserWorkflowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # ──────────────────────────────────────────
  # 1. 공개 페이지 접속
  # ──────────────────────────────────────────

  test "홈페이지 정상 응답" do
    get root_path
    assert_response :success
  end

  test "포트폴리오 페이지 정상 응답" do
    get portfolio_path
    assert_response :success
  end

  test "가격 페이지 정상 응답" do
    get pricing_path
    assert_response :success
  end

  test "연락처 페이지 정상 응답" do
    get contact_path
    assert_response :success
  end

  test "개인정보처리방침 정상 응답" do
    get privacy_path
    assert_response :success
  end

  test "이용약관 정상 응답" do
    get terms_path
    assert_response :success
  end

  test "디자인 템플릿 목록 정상 응답" do
    get design_templates_path
    assert_response :success
  end

  test "헬스체크 엔드포인트 정상 응답" do
    get rails_health_check_path
    assert_response :success
  end

  # ──────────────────────────────────────────
  # 2. 인증 벽 — 비로그인 시 로그인 페이지로 리다이렉트
  # ──────────────────────────────────────────

  test "마이페이지는 비로그인 시 로그인으로 리다이렉트" do
    get mypage_path
    assert_redirected_to new_user_session_path
  end

  test "장바구니는 비로그인 시 로그인으로 리다이렉트" do
    get cart_path
    assert_redirected_to new_user_session_path
  end

  test "주문 목록은 비로그인 시 로그인으로 리다이렉트" do
    get mypage_orders_path
    assert_redirected_to new_user_session_path
  end

  test "위시리스트는 비로그인 시 로그인으로 리다이렉트" do
    get mypage_wishlist_path
    assert_redirected_to new_user_session_path
  end

  # ──────────────────────────────────────────
  # 3. 견적 문의 플로우
  # ──────────────────────────────────────────

  test "견적 문의 정상 제출 후 리다이렉트" do
    assert_difference "Quote.count", 1 do
      post contact_path, params: {
        quote: {
          contact_name: "홍길동",
          email: "test@example.com",
          phone: "010-1234-5678",
          message: "랜딩페이지 제작 문의드립니다.",
          nickname: ""  # 허니팟 비어있음 = 사람
        }
      }
    end
    assert_redirected_to contact_path
    follow_redirect!
    assert_response :success
  end

  test "스팸봇 견적은 DB 저장 없이 리다이렉트" do
    assert_no_difference "Quote.count" do
      post contact_path, params: {
        quote: {
          contact_name: "Bot",
          email: "spam@bot.com",
          phone: "010-0000-0000",
          message: "Buy cheap meds now!",
          nickname: "bot_filled_honeypot"  # 허니팟 채워짐 = 봇
        }
      }
    end
    assert_redirected_to contact_path
  end

  test "필수 항목 누락 견적은 폼 재렌더" do
    post contact_path, params: {
      quote: {
        contact_name: "",
        email: "",
        phone: "",
        message: "",
        nickname: ""
      }
    }
    assert_response :unprocessable_entity
  end

  # ──────────────────────────────────────────
  # 4. 로그인 플로우
  # ──────────────────────────────────────────

  test "로그인 페이지 정상 응답" do
    get new_user_session_path
    assert_response :success
  end

  test "올바른 이메일/비밀번호로 로그인" do
    post user_session_path, params: {
      user: { email: "user@example.com", password: "password123" }
    }
    assert_redirected_to root_path
  end

  test "잘못된 비밀번호로 로그인 실패" do
    post user_session_path, params: {
      user: { email: "user@example.com", password: "wrong_password" }
    }
    assert_response :unprocessable_entity
  end

  # ──────────────────────────────────────────
  # 5. 인증 후 마이페이지/프로필 플로우
  # ──────────────────────────────────────────

  test "로그인 후 마이페이지 접근 가능" do
    sign_in users(:regular_user)
    get mypage_path
    assert_response :success
  end

  test "로그인 후 프로필 편집 페이지 접근" do
    sign_in users(:regular_user)
    get edit_mypage_path
    assert_response :success
  end

  test "프로필 이름 수정" do
    sign_in users(:regular_user)
    patch mypage_path, params: { user: { name: "수정된이름" } }
    assert_redirected_to mypage_path
    follow_redirect!
    assert_response :success
    assert_equal "수정된이름", users(:regular_user).reload.name
  end

  test "로그인 후 주문 목록 접근" do
    sign_in users(:regular_user)
    get mypage_orders_path
    assert_response :success
  end

  test "로그인 후 위시리스트 접근" do
    sign_in users(:regular_user)
    get mypage_wishlist_path
    assert_response :success
  end

  # ──────────────────────────────────────────
  # 6. 장바구니 플로우
  # ──────────────────────────────────────────

  test "로그인 후 장바구니 조회" do
    sign_in users(:regular_user)
    get cart_path
    assert_response :success
  end

  test "템플릿 장바구니에 추가" do
    sign_in users(:regular_user)
    template = design_templates(:one)
    assert_difference "CartItem.count", 1 do
      post add_to_cart_path, params: {
        item_type: "DesignTemplate",
        item_id: template.id
      }
    end
    assert_redirected_to cart_path
    follow_redirect!
    assert_response :success
  end

  test "동일 템플릿 재추가 시 수량 증가 (중복 추가 없음)" do
    sign_in users(:regular_user)
    template = design_templates(:one)

    post add_to_cart_path, params: { item_type: "DesignTemplate", item_id: template.id }
    assert_difference "CartItem.count", 0 do
      post add_to_cart_path, params: { item_type: "DesignTemplate", item_id: template.id }
    end

    cart = users(:regular_user).cart
    item = cart.cart_items.find_by(item_type: "DesignTemplate", item_id: template.id)
    assert_equal 2, item.quantity
  end

  test "장바구니 아이템 삭제" do
    sign_in users(:regular_user)
    template = design_templates(:one)
    post add_to_cart_path, params: { item_type: "DesignTemplate", item_id: template.id }

    cart = users(:regular_user).cart
    item = cart.cart_items.last

    assert_difference "CartItem.count", -1 do
      delete remove_item_cart_path(item)
    end
    assert_redirected_to cart_path
  end

  # ──────────────────────────────────────────
  # 7. 주문 플로우
  # ──────────────────────────────────────────

  test "빈 장바구니에서 주문 시도 시 리다이렉트" do
    sign_in users(:regular_user)
    # 장바구니 비어있는 상태에서 주문 시도
    post create_from_cart_orders_path
    assert_redirected_to cart_path
  end

  test "주문 상세 페이지 접근 (본인 주문)" do
    sign_in users(:owner)
    order = orders(:paid_order)
    get order_path(order)
    assert_response :success
  end

  test "타인 주문 접근 불가 (404 또는 리다이렉트)" do
    sign_in users(:regular_user)
    # owner의 주문에 regular_user가 접근
    order = orders(:paid_order)
    get order_path(order)
    # 권한 없음 → 리다이렉트 또는 not found
    assert_response :redirect
  end

  # ──────────────────────────────────────────
  # 8. 로그아웃
  # ──────────────────────────────────────────

  test "로그아웃 후 홈으로 리다이렉트" do
    sign_in users(:regular_user)
    delete destroy_user_session_path
    assert_redirected_to root_path
  end

  test "로그아웃 후 마이페이지 접근 차단" do
    sign_in users(:regular_user)
    delete destroy_user_session_path
    follow_redirect!
    get mypage_path
    assert_redirected_to new_user_session_path
  end

  # ──────────────────────────────────────────
  # 9. 어드민 접근 제어
  # ──────────────────────────────────────────

  test "비로그인 어드민 접근 차단" do
    get admin_root_path
    assert_response :redirect
  end

  test "일반 유저 어드민 접근 차단" do
    sign_in users(:regular_user)
    get admin_root_path
    assert_response :redirect
  end

  test "슈퍼어드민 어드민 접근 가능" do
    sign_in users(:super_admin)
    get admin_root_path
    assert_response :success
  end
end
