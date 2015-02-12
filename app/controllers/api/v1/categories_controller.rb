module Api
  module V1
    class CategoriesController < ApplicationController
      respond_to :json

      def index
        @categories = Category.all.pluck(:name, :name_jp)
        render json: { categories: @categories }
      end
    end
  end
end