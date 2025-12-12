class Rack::Attack
  # Throttle all requests by IP (60rpm)
  throttle('req/ip', limit: 60, period: 1.minute) do |req|
    req.ip
  end

  # Throttle POST requests to /quotes by IP address
  # Limit: 5 requests per 10 minutes
  throttle('quotes/ip', limit: 5, period: 10.minutes) do |req|
    if req.path == '/quotes' && req.post?
      req.ip
    end
  end

  # Throttle login attempts by IP address
  # Limit: 5 attempts per 20 seconds
  throttle('admin/login/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/admin/login' && req.post?
      req.ip
    end
  end

  # Block suspicious requests
  blocklist('block suspicious IPs') do |req|
    # Block if user agent is missing
    req.user_agent.blank?
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |request|
    [
      429,  # HTTP status code
      { 'Content-Type' => 'text/html' },
      ['<html><body><h1>요청이 너무 많습니다</h1><p>잠시 후 다시 시도해 주세요.</p></body></html>']
    ]
  end
end
