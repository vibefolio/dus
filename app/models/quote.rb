class Quote < ApplicationRecord
  WORKFLOW_STATUSES = %w[
    received first_call kakao_progress signup_order 
    payment_received in_progress review completed subscription_active
  ].freeze

  belongs_to :user, optional: true
  
  validates :contact_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :message, presence: true
  validates :status, inclusion: { in: %w[pending completed] }
  validates :workflow_status, inclusion: { in: WORKFLOW_STATUSES }

  # 상태 전환 메서드
  def advance_to!(new_status)
    unless WORKFLOW_STATUSES.include?(new_status)
      raise "유효하지 않은 상태: #{new_status}"
    end
    update!(workflow_status: new_status)
    NotificationService.notify_quote_update(self)
  end

  def advance_to_next!
    current_index = WORKFLOW_STATUSES.index(workflow_status)
    raise "이미 마지막 단계입니다." if current_index >= WORKFLOW_STATUSES.size - 1
    advance_to!(WORKFLOW_STATUSES[current_index + 1])
  end

  def workflow_label
    { 'received' => '접수', 'first_call' => '첫 통화', 'kakao_progress' => '카톡 진행',
      'signup_order' => '가입/주문', 'payment_received' => '결제 확인',
      'in_progress' => '진행 중', 'review' => '검토', 'completed' => '완료',
      'subscription_active' => '구독 활성' }[workflow_status]
  end
end
