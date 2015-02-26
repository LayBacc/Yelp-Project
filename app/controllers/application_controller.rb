class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_request_variant

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name
    devise_parameter_sanitizer.for(:sign_up) << :last_name
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def invalid_fields
  	render status: 400, json: { error: 'Invalid fields.' }
  end

  def missing_parameters
  	render status: 400, json: { error: 'Missing parameters' }
  end

  def is_float?(number)
  	number.to_f.to_s == number.to_s
  end

  def sanitize_query
  	lat = query_params[:latitude].present? ? is_float?(query_params[:latitude]) : true
  	lng = query_params[:longitude].present? ? is_float?(query_params[:longitude]) : true
  	invalid_fields and return unless lat && lng

  	missing_parameters unless query_params[:location].present? || query_params[:subarea].present? || (lat && lng)
  end

  def query_params
  	params.permit(:location, :subarea, :latitude, :longitude, :order, :category, :category_id, :page)
  end

  private

  def set_request_variant
    request.variant = :mobile if browser.mobile?
  end
end
