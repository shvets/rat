require 'acceptance_test'

shared_context "MyAcceptanceTest" do

  attr_reader :acceptance_test

  before :all do
    @acceptance_test = AcceptanceTest.new

    selenium_config_file = "#{File.expand_path(Rails.root)}/spec/features/support/selenium.yml"
    selenium_config_name = ENV['SELENIUM_CONFIG_NAME'].nil? ? "test.remote" : ENV['SELENIUM_CONFIG_NAME']

    @acceptance_test.load_selenium_config selenium_config_file, selenium_config_name
  end

  before do
    @acceptance_test.before self
  end

  after do
    @acceptance_test.after self
  end

end