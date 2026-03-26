# 견적 워크플로우 상태 관리 서비스
class QuoteWorkflowService
  WORKFLOW_STATUSES = %w[
    received first_call kakao_progress signup_order
    payment_received in_progress review completed subscription_active
  ].freeze

  # 워크플로우 상태 변경
  def self.advance(quote, to_status:)
    unless WORKFLOW_STATUSES.include?(to_status)
      return { success: false, error: "유효하지 않은 상태입니다: #{to_status}" }
    end

    if quote.update(workflow_status: to_status)
      NotificationService.notify_quote_update(quote)
      Rails.logger.info "[QuoteWorkflow] 견적 ##{quote.id} 상태 변경: #{to_status}"
      { success: true, quote: quote }
    else
      { success: false, errors: quote.errors }
    end
  end

  # 현재 상태의 다음 단계 조회
  def self.next_status(current_status)
    current_index = WORKFLOW_STATUSES.index(current_status)
    return nil if current_index.nil? || current_index >= WORKFLOW_STATUSES.length - 1

    WORKFLOW_STATUSES[current_index + 1]
  end

  # 다음 단계로 자동 진행
  def self.advance_to_next(quote)
    next_step = next_status(quote.workflow_status)
    return { success: false, error: "더 이상 진행할 단계가 없습니다." } if next_step.nil?

    advance(quote, to_status: next_step)
  end
end
