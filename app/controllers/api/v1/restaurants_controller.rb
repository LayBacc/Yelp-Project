module Api
  module V1
    class RestaurantsController < ApplicationController
      before_action :sanitize_query, only: [:index]
      respond_to :json

      def index
      end

      def show
        @restaurant = Restaurant.find(params[:id])
      	@restaurant.fill_missing
      end
    end
  end
end
