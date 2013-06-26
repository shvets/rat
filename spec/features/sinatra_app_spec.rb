require 'sinatra'

class SinatraApp < Sinatra::Base

  get "/" do
    "<h1>hello world!</h1>"
  end

  #run! if app_file == $0
end


require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara::DSL
end

set :environment, :test

Capybara.app = SinatraApp

describe SinatraApp do

  #include Capybara::DSL

  it "says hello when browsing /" do
    visit '/'
    page.should have_content('hello')
  end
end
