class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def show
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find(params[:id])
  end

  def new
    existing_review = Review.find_by(user_id: current_user.id, restaurant_id: params[:restaurant_id])
    redirect_to restaurant_review_path(restaurant_id: params[:restaurant_id], id: existing_review.id) if existing_review.present?
  	@review = Review.new
  end

  def edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find(params[:id])
  end

  def create
  	@review = Review.new(review_params)
  	if @review.save
      redirect_to restaurant_path(params[:restaurant_id])
  	end
  end

  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    redirect_to restaurant_review_path(restaurant_id: params[:restaurant_id], id: @review.id)
  end

  private

  def review_params
  	params.require(:review).permit(:body, :rating).merge({ user_id: current_user.id, restaurant_id: params[:restaurant_id] })
  end
end
