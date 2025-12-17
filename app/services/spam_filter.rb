class SpamFilter
  # 스팸 키워드 목록
  SPAM_KEYWORDS = [
    'telegram', '텔레그램', 'posevi', 'promotion', '프로모션',
    'casino', '카지노', 'viagra', 'cialis', 'loan', '대출',
    'bitcoin', '비트코인', 'crypto', 'forex', 'investment scheme',
    'click here', '여기를 클릭', 'free money', '무료 돈',
    'congratulations', '축하합니다', 'winner', '당첨',
    'limited time', '제한된 시간', 'act now', '지금 행동',
    'subscribe', '구독하세요', 'channel', '채널'
  ].freeze

  # URL 패턴 (http, https, www 포함)
  URL_PATTERN = %r{(https?://|www\.)[^\s]+}i

  # 의심스러운 도메인
  SUSPICIOUS_DOMAINS = [
    'telegram.com', 'posevi', 't.me', 'bit.ly', 'tinyurl',
    'goo.gl', 'ow.ly', 'short.link'
  ].freeze

  def self.spam?(params)
    message = params[:message].to_s.downcase
    email = params[:email].to_s.downcase
    project_type = params[:project_type].to_s.downcase

    # 1. 스팸 키워드 체크
    return true if contains_spam_keywords?(message)

    # 2. URL 링크 체크 (메시지에 URL 포함)
    return true if contains_urls?(message)

    # 3. 의심스러운 도메인 체크
    return true if contains_suspicious_domain?(message)

    # 4. 프로젝트 유형이 "???" 또는 비정상적인 경우
    return true if project_type.include?('?')

    # 5. 이메일 도메인 체크
    return true if suspicious_email?(email)

    false
  end

  def self.contains_spam_keywords?(text)
    SPAM_KEYWORDS.any? { |keyword| text.include?(keyword.downcase) }
  end

  def self.contains_urls?(text)
    text.match?(URL_PATTERN)
  end

  def self.contains_suspicious_domain?(text)
    SUSPICIOUS_DOMAINS.any? { |domain| text.include?(domain) }
  end

  def self.suspicious_email?(email)
    # 임시 이메일 서비스 도메인
    temp_email_domains = ['tempmail', 'guerrillamail', '10minutemail', 'throwaway']
    temp_email_domains.any? { |domain| email.include?(domain) }
  end

  # Rate limiting을 위한 IP 체크
  def self.rate_limited?(ip_address)
    cache_key = "quote_submission_#{ip_address}"
    submission_count = Rails.cache.read(cache_key) || 0

    # 1시간에 3번 이상 제출 시 차단
    if submission_count >= 3
      return true
    end

    # 제출 횟수 증가 및 1시간 TTL 설정
    Rails.cache.write(cache_key, submission_count + 1, expires_in: 1.hour)
    false
  end
end
