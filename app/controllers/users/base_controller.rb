module Users
  class BaseController < ApplicationController
    before_action :set_user, :verify_user_is_correct

  private
    def verify_user_is_correct
      unless current_user == @user
        render json: { message: "User is not correct" }, status: 401
      end
    end

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end
