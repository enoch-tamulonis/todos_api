module TestHelpers
  def authenticate_as_user(user, password)
    post("/users/auth", params: {
      user: {
        email: user.email,
        password: password
      }
    })
    parsed_body = JSON.parse(response.body)
    parsed_body["token"]
  end

  def encode_jwt_for_user(user)
    payload = { user: user.id }
    token = JWT.encode(payload, Rails.application.credentials.dig(:jwt_secret), "HS256")
  end
end
