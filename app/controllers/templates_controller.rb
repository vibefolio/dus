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

  def stay
    # 스테이 (감성 숙소) 템플릿
  end
end
