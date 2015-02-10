module Api
  module V1
    class RestaurantsController < ApplicationController
      before_action :sanitize_query, only: [:index]
      respond_to :json

      def index
        render json: { }
      end
    end
  end
end