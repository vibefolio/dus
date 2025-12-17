# FAQ 초기 데이터
puts "Creating FAQs..."

faqs_data = [
  {
    question: "구독을 중단하면 어떻게 되나요?",
    answer: "구독 중단 시 유지보수 및 업데이트 서비스가 종료됩니다. 다만 개발된 웹사이트는 계속 사용하실 수 있으며, 필요 시 언제든 구독을 재개하실 수 있습니다.",
    position: 1,
    published: true
  },
  {
    question: "플랜 변경이 가능한가요?",
    answer: "네, 언제든지 플랜 업그레이드 또는 다운그레이드가 가능합니다. 차액은 다음 결제 시 정산됩니다.",
    position: 2,
    published: true
  },
  {
    question: "초기 개발 기간은 얼마나 걸리나요?",
    answer: "베이직 플랜은 1주 이내 / 프로플랜은 1~2주 / 마스터플랜은 2~4주 이상 소요됩니다.",
    position: 3,
    published: true
  },
  {
    question: "도메인과 호스팅 비용은 포함되나요?",
    answer: "도메인과 호스팅 비용은 별도입니다. 포함시 별도의 비용이 발생할 수 있습니다.",
    position: 4,
    published: true
  }
]

faqs_data.each do |faq_data|
  Faq.find_or_create_by(question: faq_data[:question]) do |faq|
    faq.answer = faq_data[:answer]
    faq.position = faq_data[:position]
    faq.published = faq_data[:published]
  end
end

puts "Created #{Faq.count} FAQs"
