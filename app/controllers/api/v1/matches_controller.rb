module Api
  module V1
    class MatchesController < ApplicationController
      before_action :sanitize_query, only: [:index]
      respond_to :json

      def index
        @restaurants = Restaurant.query(query_params).with_default_image.random(10)
      end

      def create
        @match = Match.create(match_params)
        MatchStat.add_match(@match)
        render json: { status: 'OK' }
      end

      private

      def match_params
        params.require(:match).permit(:first_id, :second_id, :winner, :category_id).merge(user_id: vote_user_id)
      end
    end
  end
end
