class UsersController < ApplicationController
  skip_before_action :verify_jwt, only: [:create]
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: "User was created successfully", token: encode_jwt_for_user(@user) }
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
