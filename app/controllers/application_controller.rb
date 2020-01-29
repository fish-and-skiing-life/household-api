
class ApplicationController < ActionController::API

  
  include Api::ErrorHandlers

  before_action :authenticate_request!, except: [:new, :create]
end
