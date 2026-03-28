# 중앙 집중식 알림 처리 서비스
class NotificationService
  def self.notify(user:, action:, message:, data: {})
    Rails.logger.info "[Notification] #{action}: #{message} (user: #{user.id})"
    # Future: ActionCable broadcast, push notification
    # NotificationsChannel.broadcast_to(user, action: action, message: message, data: data)
    { action: action, message: message, data: data }
  end

  # 주문 상태 변경 알림
  def self.notify_order_status(order)
    return unless order.user

    notify(
      user: order.user,
      action: 'order_status',
      message: "주문 상태: #{order.status}",
      data: { order_id: order.id, status: order.status }
    )
  end

  # 견적 상태 변경 알림
  def self.notify_quote_update(quote)
    return unless quote.user

    notify(
      user: quote.user,
      action: 'quote_update',
      message: "견적 상태: #{quote.workflow_status}",
      data: { quote_id: quote.id, workflow_status: quote.workflow_status }
    )
  end

  # 에이전시 생성 완료 알림
  def self.notify_agency_created(agency)
    return unless agency.owner

    notify(
      user: agency.owner,
      action: 'agency_created',
      message: "에이전시 '#{agency.name}'이(가) 생성되었습니다.",
      data: { agency_id: agency.id }
    )
  end
end
