module Admin
  class FaqsController < AdminController
    before_action :set_faq, only: [:edit, :update, :destroy]

    def index
      @faqs = Faq.unscoped.order(position: :asc, created_at: :desc)
    end

    def new
      @faq = Faq.new
    end

    def create
      @faq = Faq.new(faq_params)
      
      if @faq.save
        redirect_to admin_faqs_path, notice: 'FAQ가 성공적으로 생성되었습니다.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @faq.update(faq_params)
        redirect_to admin_faqs_path, notice: 'FAQ가 성공적으로 수정되었습니다.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @faq.destroy
      redirect_to admin_faqs_path, notice: 'FAQ가 성공적으로 삭제되었습니다.'
    end

    private

    def set_faq
      @faq = Faq.find(params[:id])
    end

    def faq_params
      params.require(:faq).permit(:question, :answer, :position, :published)
    end
  end
end
