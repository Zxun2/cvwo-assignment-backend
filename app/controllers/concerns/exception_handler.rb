# set_todo - callback method to find a todo by id. In the case where the record does not exist, ActiveRecord will throw
# an exception ActiveRecord::RecordNotFound. 
# We’ll rescue from this exception and return a 404 message.
module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :code_422
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :code_422
    rescue_from ExceptionHandler::InvalidToken, with: :code_422

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def code_422(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end
end