class AuthorizeApiRequest
  include AuthenticationHelper, ExceptionHandler

  def self.call(headers = {})
    new(headers).call
  end

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user = user_from_token
    user || handle_unauthorized
  end

  private

  attr_reader :headers

  def user_from_token
    if headers["Authorization"].present?
      token = headers["Authorization"].split(" ").last
      decoded = decode_token(token)
      User.find(decoded[:user_id]) if decoded
    end
  rescue
    nil
  end
end
