# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../../config/environment',  __FILE__)

require 'sinatra'
require 'grape'

require File.expand_path('../../app/api/rat_api', __FILE__)

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end

require 'sinatra/base'

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end

use Rack::Session::Cookie, :key => 'key',
    :domain => "localhost",
    :path => '/',
    :expire_after => 14400, # In seconds
    :secret => 'secret'

run Rack::Cascade.new [Rat::API, Web]



