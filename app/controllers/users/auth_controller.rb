# frozen_string_literal: true

module Users
  class AuthController < ApplicationController
    skip_before_action :verify_jwt
    def create
      @user = User.find_by_email(user_params[:email])
      if @user&.authenticate(user_params[:password])
        render json: { message: "user was authed", token: encode_jwt_for_user(@user) }
      else
        render json: { errors: ["no user was found with those credentials"] }, status: :unprocessable_entity
      end
    end
  private
    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
