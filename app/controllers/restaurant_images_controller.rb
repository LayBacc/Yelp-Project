class RestaurantImagesController < ApplicationController
  include Transloadit::Rails::ParamsDecoder

  before_action :authenticate_user!, only: [:new, :create]

  def index
  	@restaurant = Restaurant.find(params[:restaurant_id])
    if params[:user]
      # TODO - select all images uploaded by user
    else
     	@images = @restaurant.images
    end
  end

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant_image = RestaurantImage.new
  end

  def create
    if params[:transloadit][:ok] == "ASSEMBLY_COMPLETED"
      params[:transloadit][:results][':original'].each do |result|
      	RestaurantImage.create(restaurant_id: params[:restaurant_id], url: result[:url])
      end
    end

    redirect_to restaurant_restaurant_images_path(params[:restaurant_id])
  end

  def update
    @restaurant_image = RestaurantImage.find(params[:id])
    @restaurant_image.update(image_params)
    redirect_to restaurant_restaurant_images_path(params[:restaurant_id])
  end

  private

  def image_params
    params.require(:restaurant_image).permit(:url, :description)
  end
end
