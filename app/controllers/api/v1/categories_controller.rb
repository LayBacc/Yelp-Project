module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :single_query, only: [:index]

      respond_to :json

      def index
      	if params[:term].present?
      	  @categories = Category.where("name LIKE '#{params[:term]}%'").pluck(:name)
        else
          @categories = Category.all.pluck(:id, :name_jp)
        end
        render json: @categories
      end

      private

      def single_query
      	render status: 400, json: {} unless params[:term].nil? || params[:term].split(' ').size == 1
      end
    end
  end
end
