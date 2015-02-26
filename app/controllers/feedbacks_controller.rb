class FeedbacksController < ApplicationController
  PER_PAGE = 20

  def index
  	@feedbacks = Feedback.paginate(page: params[:page], per_page: PER_PAGE)
  end
end
