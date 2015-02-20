module Api
  module V1
    class ReviewsController < ApplicationController
      respond_to :json

      def index
      	@reviews = Review.where(restaurant_id: params[:restaurant_id])
      end
    end
  end
end
