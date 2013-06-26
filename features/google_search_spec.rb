ENV["RAILS_ENV"] ||= 'test'
puts "Environment: #{ENV["RAILS_ENV"]}"

require 'rspec'
require 'rspec/example_steps'
require "capybara-webkit"

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.app_host       = "http://google.com"
Capybara.default_driver = :selenium

describe "Searching" do
  Steps "Result found" do

    Given "I am on google.com" do
      visit('/')
    end

    When "I enter \"Capybara\"" do
      fill_in('q', :with => "Capybara")
    end

    When "click submit button" do
      if Capybara.current_driver == :selenium
        find("#gbqfbw button").click
      else
        has_selector? ".gsfs .gssb_g span.ds input.lsb", :visible => true # wait for ajax to be finished

        button = first(".gsfs .gssb_g span.ds input.lsb")

        button.click
      end
    end

    Then "I should see results" do
      page.should have_content("Capybara")
    end

  end
end


