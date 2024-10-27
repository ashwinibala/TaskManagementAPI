class AuthenticationController < ApplicationController
  include AuthenticationHelper

  skip_before_action :authenticate_request, only: [ :login, :register ]

  # User Registration
  def register
    @user = User.new(user_params)

    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # User Login
  def login
    begin
      validation_errors = UserValidator.validate_login_params(params)
      return render json: { errors: validation_errors }, status: :unprocessable_entity if validation_errors.any?

      user = User.find_for_database_authentication(email: params[:email])

      if user
        if user.valid_password?(params[:password])
          token = encode_token(user.id)
          render json: { token: token, user: { id: user.id, email: user.email } }, status: :ok
        else
          render json: { error: "Invalid password" }, status: :unauthorized
        end
      else
        render json: { error: "User not found" }, status: :not_found
      end
    rescue StandardError => e
      Rails.logger.error("Authentication error: #{e.message}")

      render json: { error: "Internal server error. Please try again later." }, status: :internal_server_error
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
