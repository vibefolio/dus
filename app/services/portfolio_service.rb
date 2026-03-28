# 포트폴리오 관리 서비스
class PortfolioService
  # 포트폴리오 생성
  def self.create(agency:, params:)
    portfolio = agency.portfolios.build(params)
    if portfolio.save
      { success: true, portfolio: portfolio }
    else
      { success: false, errors: portfolio.errors }
    end
  end

  # 포트폴리오 수정
  def self.update(portfolio, params:)
    if portfolio.update(params)
      { success: true, portfolio: portfolio }
    else
      { success: false, errors: portfolio.errors }
    end
  end

  # 포트폴리오 삭제
  def self.destroy(portfolio)
    portfolio.destroy
    { success: true }
  end
end
