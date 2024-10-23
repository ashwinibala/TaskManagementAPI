module AuthenticationHelper
  def encode_token(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.credentials[:jwt_secret], "HS256")
  end

  def decode_token(token)
    begin
      JWT.decode(token, Rails.application.credentials[:jwt_secret], true, { algorithm: "HS256" })[0].symbolize_keys
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
