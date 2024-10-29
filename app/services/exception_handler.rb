module ExceptionHandler
  def handle_unauthorized
    raise(ExceptionHandler::Unauthorized, Message.unauthorized)
  end

  def handle_error(e)
    { error: e.message }
  end
end
