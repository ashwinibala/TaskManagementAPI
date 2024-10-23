class UserValidator
  def self.validate_login_params(params)
    errors = []
    errors << "Email is required" if params[:email].blank?
    errors << "Password is required" if params[:password].blank?
    errors
  end
end
