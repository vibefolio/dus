require "prawn"
require "prawn/table"

class Admin::QuotesController < ApplicationController
  layout "admin"
  http_basic_authenticate_with name: ENV.fetch("ADMIN_USERNAME", "admin"), password: ENV.fetch("ADMIN_PASSWORD", "password123")
  before_action :set_quote, only: [ :show ]

  def index
    @quotes = Quote.order(created_at: :desc)
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = generate_quote_pdf(@quote)
        send_data pdf.render,
          filename: "quote_#{@quote.id}_#{Date.today}.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end

  def generate_quote_pdf(quote)
    Prawn::Document.new do |pdf|
      # Windows Korean Font Support
      font_path = "C:/Windows/Fonts/malgun.ttf"
      if File.exist?(font_path)
        pdf.font font_path
      end

      pdf.text "견적 문의 상세 (Quote Detail)", size: 24, style: :bold, align: :center
      pdf.move_down 30

      # Meta Info
      pdf.text "접수 번호: ##{quote.id}", size: 12
      pdf.text "접수 일자: #{quote.created_at.strftime('%Y-%m-%d %H:%M')}", size: 12
      pdf.text "현재 상태: #{quote.status}", size: 12
      pdf.move_down 20

      pdf.stroke_horizontal_rule
      pdf.move_down 20

      # Client Info
      pdf.text "고객 정보", size: 16, style: :bold
      pdf.move_down 10
      
      client_data = [
        ["담당자명", quote.contact_name],
        ["회사명", quote.company_name || "-"],
        ["이메일", quote.email],
        ["연락처", quote.phone]
      ]
      
      pdf.table(client_data, width: pdf.bounds.width) do
        cells.padding = 8
        cells.borders = [:bottom]
        column(0).font_style = :bold
        column(0).width = 100
      end

      pdf.move_down 30

      # Project Info
      pdf.text "프로젝트 정보", size: 16, style: :bold
      pdf.move_down 10

      project_data = [
        ["프로젝트 유형", quote.project_type],
        ["예산", quote.budget]
      ]

      pdf.table(project_data, width: pdf.bounds.width) do
        cells.padding = 8
        cells.borders = [:bottom]
        column(0).font_style = :bold
        column(0).width = 100
      end

      pdf.move_down 30

      # Message
      pdf.text "문의 내용", size: 16, style: :bold
      pdf.move_down 10
      pdf.text quote.message, size: 11, leading: 4

      # Footer
      pdf.number_pages "Page <page> of <total>", at: [pdf.bounds.right - 150, 0], width: 150, align: :right, size: 10
    end
  end
end
