require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    it "Creates a new user" do
      user_params = {
        email: "testemail@testmailer.com",
        password: "TestPassword555",
      }
      post("/users", params: { user: user_params })
      expect(response.status).to(eq(200))
      expect(User.last.email).to(eq(user_params[:email]))
    end

    it "Does not create if email is invalid" do
      user_params = {
        email: "a invalid email @testmail.com",
        password: "TestPassword555",
      }
      post("/users", params: { user: user_params })
      expect(response.status).to(eq(422))
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["errors"]).to have_key("email")
    end

    it "Does not create if password is blank" do
      user_params = {
        email: "testemail@testmailer.com",
      }
      post("/users", params: { user: user_params })
      expect(response.status).to(eq(422))
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["errors"]).to have_key("password")
    end
  end
end
