class ApplicationController < ActionController::API
  attr_reader :current_user

  protected
  def authenticate_request
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized and return
    end
  end

  private
  def http_token
    @http_token ||= validate_authorization
  end

  def auth_token
    @auth_token = JsonWebToken.decode(http_token)
  end

  def validate_authorization
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def user_id_in_token?
    http_token && auth_token && auth_token.first.with_indifferent_access[:user_id].to_i
  end
end
