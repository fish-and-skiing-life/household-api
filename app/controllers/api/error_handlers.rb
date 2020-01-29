
module Api::ErrorHandlers
  extend ActiveSupport::Concern

  #attr_accessor :status, :message



  included do
    rescue_from StandardError, :with => :rescue_exception
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  end

  private


  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end 

  def rescue_exception(e)
    @message = e.message

    render json: { message: @message }, status: 500
  end

  def rescuable?(e)
    return e.is_a?(Api::Exceptions::RescuableException) || RESCUABLE_EXCEPTIONS.has_key?(e.to_s.to_sym)
  end

  def setup
  end
end

