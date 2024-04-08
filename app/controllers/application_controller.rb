class ApplicationController < ActionController::API
  before_action :authorize_request!

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: I18n.t('errors.unauthorized_access') }, status: :unauthorized
  end


  private

  def authorize_request!
    render json: { error: I18n.t('errors.unauthorized_access') }, status: :unauthorized unless current_user
  end

  def current_user
    @current_user = User.find(decoded_token['id']) if decoded_token
end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials[:secret_key_base])
  end

  def decoded_token
    header = request.headers['Authorization']
    if header
      token = header.split(' ').last
      begin
        JWT.decode(token, Rails.application.credentials[:secret_key_base]).first
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
