require File.expand_path(File.dirname(__FILE__) + '/support/features_spec_helper')

feature 'Google Search', %q{
    As a user of this service
    I want to enter a search text and get the relevant search results
    so that I can find the right answer
  } do
  include_context "AcceptanceTest", @@support

  before :all do
    @@support.app_host = "http://www.google.com"
  end

  scenario "uses selenium driver", driver: :selenium, exclude: false do
    visit('/')

    fill_in "q", :with => "Capybara"

    #save_and_open_page

    find("#gbqfbw button").click

    all(:xpath, "//li[@class='g']/h3/a").each { |a| puts a[:href] }
  end

  scenario "uses webkit driver", driver: :webkit do
    visit('/')

    fill_in "q", :with => "Capybara"

    #save_and_open_page

    has_selector? ".gsfs .gssb_g span.ds input.lsb", :visible => true # wait for ajax to be finished

    button = first(".gsfs .gssb_g span.ds input.lsb")

    button.click

    all(:xpath, "//li[@class='g']/h3/a").each { |a| puts a[:href] }
  end

  #scenario "uses poltergeist driver", driver: :poltergeist do
  #  visit('/')
  #
  #  fill_in "q", :with => "Capybara"
  #
  #  #save_and_open_page
  #
  #  has_selector? ".gsfs .gssb_g span.ds input.lsb", :visible => true # wait for ajax to be finished
  #
  #  button = first(".gsfs .gssb_g span.ds input.lsb")
  #
  #  button.click
  #
  #  all(:xpath, "//li[@class='g']/h3/a").each { |a| puts a[:href] }
  #end
end