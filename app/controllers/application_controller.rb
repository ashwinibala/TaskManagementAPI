class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  protect_from_forgery with: :null_session

  attr_reader :current_user

  # before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      begin
        @current_user = User.find(decode_token(token)[:user_id])
      rescue ExceptionHandler::Unauthorized => e
        render json: { error: e.message }, status: :unauthorized
      end
    else
      render json: { error: "Token is missing" }, status: :unauthorized
    end
  end
end
