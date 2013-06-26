require 'create_custom_view'

class ApplicationController < ActionController::Base
  include CreateCustomView

  protect_from_forgery
end
