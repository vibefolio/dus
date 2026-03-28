# 에이전시 생명주기 관리 서비스
class AgencyManagementService
  # 유저를 위한 에이전시 생성 (Order#create_agency_for_user 로직 추출)
  def self.create_for_user(user, options = {})
    # 이미 에이전시 소유자라면 중복 생성 방지
    if user.agency_owner? && Agency.exists?(owner_id: user.id)
      return { success: false, error: "이미 에이전시를 소유하고 있습니다." }
    end

    agency = Agency.create!(
      name: options[:name] || "#{user.name || 'New'}님의 사이트",
      subdomain: options[:subdomain] || "site-#{SecureRandom.hex(4)}",
      owner: user,
      parent_agency: user.agency,
      active: false # 관리자 승인 또는 설정 완료 후 활성화
    )

    # 유저 권한 업그레이드
    user.update!(role: 'owner')

    NotificationService.notify_agency_created(agency)

    { success: true, agency: agency }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end

  # 관리자 추가
  def self.add_admin(agency, user)
    admin_ids = agency.admin_ids || []
    return { success: false, error: "이미 관리자입니다." } if admin_ids.include?(user.id)

    admin_ids << user.id
    if agency.update(admin_ids: admin_ids)
      { success: true, agency: agency }
    else
      { success: false, errors: agency.errors }
    end
  end

  # 관리자 제거
  def self.remove_admin(agency, user)
    admin_ids = (agency.admin_ids || []) - [user.id]
    if agency.update(admin_ids: admin_ids)
      { success: true, agency: agency }
    else
      { success: false, errors: agency.errors }
    end
  end
end
