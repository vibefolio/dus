require "test_helper"

class AgencyTest < ActiveSupport::TestCase
  # === 밸리데이션 ===

  test "유효한 에이전시 생성" do
    agency = Agency.new(
      name: "새 에이전시",
      subdomain: "new-agency",
      owner: users(:regular_user)
    )
    assert agency.valid?
  end

  test "name 필수값 확인" do
    agency = Agency.new(
      subdomain: "no-name",
      owner: users(:regular_user)
    )
    assert_not agency.valid?
    assert_includes agency.errors[:name], "can't be blank"
  end

  test "subdomain 필수값 확인" do
    agency = Agency.new(
      name: "서브도메인 없음",
      owner: users(:regular_user)
    )
    assert_not agency.valid?
    assert_includes agency.errors[:subdomain], "can't be blank"
  end

  test "subdomain 유일성 확인" do
    existing = agencies(:main_agency)
    agency = Agency.new(
      name: "중복 서브도메인",
      subdomain: existing.subdomain,
      owner: users(:regular_user)
    )
    assert_not agency.valid?
    assert_includes agency.errors[:subdomain], "has already been taken"
  end

  test "subdomain 소문자 영숫자 + 하이픈만 허용" do
    valid_subdomains = %w[test test-agency my-site-123 a 123]
    valid_subdomains.each do |subdomain|
      agency = Agency.new(
        name: "테스트",
        subdomain: subdomain,
        owner: users(:regular_user)
      )
      assert agency.valid?, "#{subdomain}은 유효한 서브도메인이어야 합니다"
    end
  end

  test "subdomain 대문자 불가" do
    agency = Agency.new(
      name: "대문자",
      subdomain: "TestAgency",
      owner: users(:regular_user)
    )
    assert_not agency.valid?
    assert_includes agency.errors[:subdomain], "is invalid"
  end

  test "subdomain 공백 불가" do
    agency = Agency.new(
      name: "공백",
      subdomain: "test agency",
      owner: users(:regular_user)
    )
    assert_not agency.valid?
  end

  test "subdomain 특수문자 불가" do
    invalid_subdomains = %w[test.agency test_agency test@agency test!]
    invalid_subdomains.each do |subdomain|
      agency = Agency.new(
        name: "테스트",
        subdomain: subdomain,
        owner: users(:regular_user)
      )
      assert_not agency.valid?, "#{subdomain}은 유효하지 않은 서브도메인이어야 합니다"
    end
  end

  # === 연관관계 ===

  test "belongs_to owner 연관관계" do
    agency = agencies(:main_agency)
    assert_equal users(:owner), agency.owner
  end

  test "has_many sub_agencies 재귀 연관관계" do
    parent = agencies(:main_agency)
    child = agencies(:sub_agency)
    assert_includes parent.sub_agencies, child
    assert_equal parent, child.parent_agency
  end

  test "parent_agency는 optional" do
    agency = agencies(:main_agency)
    assert_nil agency.parent_agency
    assert agency.valid?
  end

  test "has_many users 연관관계" do
    agency = agencies(:main_agency)
    assert_respond_to agency, :users
  end

  test "has_many orders 연관관계" do
    agency = agencies(:main_agency)
    assert_respond_to agency, :orders
  end

  # === 직렬화 필드 ===

  test "settings Hash 직렬화" do
    agency = agencies(:main_agency)
    assert_kind_of Hash, agency.settings
  end

  test "admin_ids Array 직렬화" do
    agency = agencies(:main_agency)
    assert_kind_of Array, agency.admin_ids
  end

  test "admins 메서드로 관리자 유저 조회" do
    agency = agencies(:main_agency)
    admin = users(:admin_user)
    agency.update!(admin_ids: [admin.id])

    admins = agency.admins
    assert_includes admins, admin
  end

  test "admins 메서드 빈 배열일 때 빈 결과" do
    agency = agencies(:main_agency)
    agency.update!(admin_ids: [])
    assert_empty agency.admins
  end
end
