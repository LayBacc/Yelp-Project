module Api
  module V1
    class LocationsController < ApplicationController
      respond_to :json

      def subareas
        @subareas = Subarea.where("LOWER(name) LIKE '%#{params[:term].downcase}%'").limit(5).pluck(:name)
        render json: @subareas
      end
    end
  end
end
