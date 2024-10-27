module AuthenticationHelper
  def encode_token(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    # secret = Rails.application.credentials[:jwt_secret] || ENV["JWT_SECRET"] || "default_secret_key"
    secret = "ce7bac9a8fc03a557603c9c55584baa0e5634b120cb47a95e78789e8bd1583a96d05893fffe810d1f921eaa36b4b85bb660a1f8703514f2b08d57a0943e70d47"
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.config.secret_key_base, "HS256")
    # JWT.encode(payload, secret, "HS256")
  end

  def decode_token(token)
    # secret = Rails.application.credentials[:jwt_secret] || ENV["JWT_SECRET"] || "default_secret_key"
    secret = "ce7bac9a8fc03a557603c9c55584baa0e5634b120cb47a95e78789e8bd1583a96d05893fffe810d1f921eaa36b4b85bb660a1f8703514f2b08d57a0943e70d47"
    begin
      JWT.decode(token, Rails.application.config.secret_key_base, true, { algorithm: "HS256" })[0].symbolize_keys
      # decoded_token = JWT.decode(token, secret, true, { algorithm: "HS256" })[0]
      # decoded_token.symbolize_keys
    rescue JWT::ExpiredSignature
      raise(ExceptionHandler::Unauthorized, "Token has expired")
    rescue JWT::DecodeError
      raise(ExceptionHandler::Unauthorized, "Invalid token")
    rescue StandardError => e
      Rails.logger.error("Error decoding JWT: #{e.message}")
      raise(ExceptionHandler::Unauthorized, "Error decoding JWT")
    end
  end
end
