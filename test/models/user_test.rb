require "test_helper"

class UserTest < ActiveSupport::TestCase
  # === Devise 인증 ===

  test "유효한 이메일과 비밀번호로 유저 생성" do
    user = User.new(
      email: "new@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.valid?
  end

  test "이메일 없이 유저 생성 불가" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "비밀번호 없이 유저 생성 불가" do
    user = User.new(email: "test@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "중복 이메일 유저 생성 불가" do
    existing = users(:regular_user)
    user = User.new(
      email: existing.email,
      password: "password123"
    )
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "짧은 비밀번호 유저 생성 불가" do
    user = User.new(email: "short@example.com", password: "12345")
    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 6 characters)"
  end

  # === 역할 확인 메서드 ===

  test "super_admin? 역할 확인" do
    user = users(:super_admin)
    assert user.super_admin?
    assert_not user.agency_owner?
    assert_not user.agency_admin?
  end

  test "agency_owner? 역할 확인" do
    user = users(:owner)
    assert user.agency_owner?
    assert_not user.super_admin?
    assert_not user.agency_admin?
  end

  test "agency_admin? 역할 확인" do
    user = users(:admin_user)
    assert user.agency_admin?
    assert_not user.super_admin?
    assert_not user.agency_owner?
  end

  test "일반 유저는 모든 역할 확인 false" do
    user = users(:regular_user)
    assert_not user.super_admin?
    assert_not user.agency_owner?
    assert_not user.agency_admin?
  end

  test "ROLES 상수 정의 확인" do
    assert_equal %w[super_admin owner admin user], User::ROLES
  end

  # === 연관관계 ===

  test "has_one cart 연관관계" do
    user = users(:regular_user)
    assert_respond_to user, :cart
  end

  test "has_many orders 연관관계" do
    user = users(:regular_user)
    assert_respond_to user, :orders
    assert_kind_of ActiveRecord::Associations::CollectionProxy, user.orders
  end

  test "has_many likes 연관관계" do
    user = users(:regular_user)
    assert_respond_to user, :likes
  end

  test "has_many quotes 연관관계" do
    user = users(:regular_user)
    assert_respond_to user, :quotes
  end

  test "belongs_to agency (optional) 연관관계" do
    # agency 없는 유저도 유효
    user = users(:regular_user)
    assert user.valid?

    # agency 있는 유저도 유효
    user_with_agency = users(:owner)
    assert user_with_agency.valid?
    assert_not_nil user_with_agency.agency
  end

  # === from_omniauth 클래스 메서드 ===

  test "from_omniauth 새 유저 생성" do
    auth = OpenStruct.new(
      provider: "google_oauth2",
      uid: "new_uid_999",
      info: OpenStruct.new(
        email: "newgoogle@example.com",
        name: "새구글유저",
        image: "https://example.com/photo.jpg"
      )
    )

    assert_difference "User.count", 1 do
      user = User.from_omniauth(auth)
      assert_equal "newgoogle@example.com", user.email
      assert_equal "새구글유저", user.name
      assert_equal "https://example.com/photo.jpg", user.image
      assert_equal "google_oauth2", user.provider
      assert_equal "new_uid_999", user.uid
    end
  end

  test "from_omniauth 기존 유저 반환" do
    existing = users(:google_user)
    auth = OpenStruct.new(
      provider: existing.provider,
      uid: existing.uid,
      info: OpenStruct.new(
        email: existing.email,
        name: existing.name,
        image: "https://example.com/photo.jpg"
      )
    )

    assert_no_difference "User.count" do
      user = User.from_omniauth(auth)
      assert_equal existing.id, user.id
    end
  end
end
