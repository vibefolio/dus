class TemplatesController < ApplicationController
  # 템플릿 페이지는 기존 사이트의 헤더/푸터를 쓰지 않고 독립적인 디자인을 가집니다.
  layout "template_preview"

  # 모든 템플릿 액션을 동적으로 처리
  %w[
    beauty dining gym study stay corporate ecommerce cafe portfolio 
    medical law wedding cleaning agency consulting academy sculpt yoga 
    nail barber flower burger wine salad dessert donut kinder startup 
    rental finance dental vet tax accounting camping studio petshop hotel pension 
    cloth shoe bag shopping learnhub english artistry
  ].each do |template_name|
    define_method(template_name) do
      # 각 뷰는 app/views/templates/#{template_name}.html.erb
    end
  end
end
