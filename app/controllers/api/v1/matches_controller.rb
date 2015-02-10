module Api
  module V1
    class MatchesController < ApplicationController
      before_action :sanitize_query, only: [:index]
      respond_to :json

      # TODO - allow for location string in params
      def index
        @restaurants = Restaurant.random(10) # Restaurant.match(query_params[:latitude].to_f, query_params[:longitude].to_f, query_params[:category_id], 10)
        render json: { restaurants: @restaurants }
      end
    end
  end
end