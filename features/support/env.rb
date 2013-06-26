ENV["RAILS_ENV"] ||= 'test'
puts "Environment: #{ENV["RAILS_ENV"]}"

require 'capybara/cucumber'
require "capybara-webkit"
require 'cucumber/rails'

#Capybara.app_host = "http://localhost:3000"
Capybara.default_driver = :selenium