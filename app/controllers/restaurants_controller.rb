class RestaurantsController < ApplicationController
  before_action :sanitize_query, only: [:index, :random]

  def index
    # Restaurant.query(query_params)
  end
end
