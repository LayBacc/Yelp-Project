class RestaurantsController < ApplicationController
  PER_PAGE = 20

  before_action :sanitize_query, only: [:index, :random]

  def index
    @restaurants = Restaurant.query(query_params).with_default_image.paginate(page: params[:page], per_page: PER_PAGE)
  end

  def show
  	@restaurant = Restaurant.find(params[:id])
  end
end
