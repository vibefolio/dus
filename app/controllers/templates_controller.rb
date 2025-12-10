class TemplatesController < ApplicationController
  # 템플릿 페이지는 기존 사이트의 헤더/푸터를 쓰지 않고 독립적인 디자인을 가집니다.
  layout "template_preview"

  def beauty
    # 뷰티 (청담동 살롱) 템플릿
  end

  def dining
    # 다이닝 (모던 한식) 템플릿
  end

  def gym
    # 짐/요가 (아티스틱 웰니스) 템플릿
  end

  def study
    # 스터디 (포커스 랩) 템플릿
  end

  def corporate
    # 기업 (Novus)
  end

  def ecommerce
    # 쇼핑몰 (AETHER)
  end

  def cafe
    # 카페 (Daily Crumb)
  end

  def portfolio
    # 포트폴리오 (ARCHIVE)
  end

  def medical
    # 병원 (Pure Clinic)
  end

  def law
    # 법률 (Trust & Logic)
  end

  def wedding
    # 웨딩 (Bliss)
  end
end
