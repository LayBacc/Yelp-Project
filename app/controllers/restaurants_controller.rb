class RestaurantsController < ApplicationController
  PER_PAGE = 20

  before_action :sanitize_query, only: [:index, :random]

  def index
    @restaurants = Restaurant.query(query_params).paginate(page: params[:page], per_page: PER_PAGE)
  end
end
