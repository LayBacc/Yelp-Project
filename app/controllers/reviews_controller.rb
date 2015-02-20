class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def new
  	@review = Review.new
  end

  def create
  	@review = Review.new(review_params)
  	if @review.save
      redirect_to restaurant_path(review_params[:restaurant_id])
  	end
  end

  private

  def review_params
  	params.require(:review).permit(:body, :rating, :restaurant_id).merge({ user_id: current_user.id })
  end
end
