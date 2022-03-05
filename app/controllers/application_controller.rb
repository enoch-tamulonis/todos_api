class ApplicationController < ActionController::API
  before_action :verify_jwt

  def current_user
    verify_jwt && User.find_by_id(decoded_token[0]["user"])
  end

  def verify_jwt
    begin
      decoded_token
    rescue JWT::DecodeError
      render json: { message: "JWT token was incorrect" }, status: 401
    end
  end

  def encode_jwt_for_user(user)
    payload = { user: user.id }
    token = JWT.encode(payload, Rails.application.credentials.dig(:jwt_secret), "HS256")
  end
private
  def decoded_token
    JWT.decode(request.headers[:token], Rails.application.credentials.dig(:jwt_secret), true, { algorithm: 'HS256' })
  end
end
