module Api
  module V1
    class VisitsController < ApplicationController
      respond_to :json

      def create
      	if signed_in?
          @visit = Visit.find_or_create(restaurant_id: visit_params, user_id: current_user.id)
      	  @visit.update(visit_params)
      	else
      	  @visit = Visit.create(visit_params)
      	end
      	render json: { status: 'OK' }
      end

      private

      def visit_params
      	params.require(:visit).permit(:restaurant_id, :visited).merge(user_id: vote_user_id)
      end
    end
  end
end
