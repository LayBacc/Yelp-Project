module Api
  module V1
    class LocationsController < ApplicationController
      respond_to :json

      def subareas
        @subareas = Subarea.where("name LIKE '%#{params[:term]}%'").pluck(:name)
        render json: @subareas
      end
    end
  end
end
