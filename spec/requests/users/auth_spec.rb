require 'rails_helper'

RSpec.describe "Users::Auth", type: :request do
  fixtures :users
  describe "POST /users/auth" do
    before do
      @user = users(:user1)
    end

    it "authenticates the user if the email and password are correct " do
      post("/users/auth", params: {
        user: {
          email: @user.email,
          password: "atestpassword",
        }
      })
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["token"]).to eq(encode_jwt_for_user(@user))
    end

    it "does not authenticate if the email is valid and password is wrong" do
      post("/users/auth", params: {
        user: {
          email: @user.email,
          password: "wrongpassword",
        }
      })
      expect(response.status).to eq(422)
    end
  end
end
