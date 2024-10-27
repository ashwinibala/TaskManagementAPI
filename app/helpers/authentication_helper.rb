module AuthenticationHelper
  def encode_token(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    secret = Rails.application.credentials[:jwt_secret] || ENV["JWT_SECRET"] || "default_secret_key" # Fallback to an environment variable or default
    JWT.encode(payload, secret, "HS256")
  end

  def decode_token(token)
    secret = Rails.application.credentials[:jwt_secret] || ENV["JWT_SECRET"] || "default_secret_key" # Fallback to an environment variable or default
    begin
      decoded_token = JWT.decode(token, secret, true, { algorithm: "HS256" })[0]
      decoded_token.symbolize_keys
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
