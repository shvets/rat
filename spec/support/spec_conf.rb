#module Helpers
#  def without_resynchronize
#    page.driver.options[:resynchronize] = false
#    yield
#    page.driver.options[:resynchronize] = true
#  end
#end

class SpecConf

  def self.require_spork
    begin
      require 'spork'

      spork_installed = true
    rescue Exception => e
      puts "spork gem is not installed."

      spork_installed = false
    end

    if spork_installed
      begin
        require 'spork/ext/ruby-debug'
      rescue Exception => e
        puts "Problem with spork/ext/ruby-debug library."
      end
    end

    spork_installed
  end

  def self.with_spork &code
    spork_installed = SpecConf.require_spork

    if spork_installed
      Spork.prefork(false) do
        code.call({})
      end
      Spork.each_run do
        require 'factory_girl_rails'

        FactoryGirl.reload
      end
    else
      code.call({})
    end
  end

  def self.init_core_spec
    ENV["RAILS_ENV"] ||= 'test'
    puts "Environment: #{ENV["RAILS_ENV"]}"

    require File.dirname(__FILE__) + "/../../config/environment"
  end

  def self.init_spec
    init_core_spec

    #ENV["RAILS_ENV"] ||= 'test'
    #puts "Environment: #{ENV["RAILS_ENV"]}"

    require 'zip_dsl'
    #require 'active_record/connection_adapters/jdbc_adapter'

    #require File.expand_path("../../../config/environment", __FILE__)

    require 'tiny_cms'

    require 'rspec/rails'
    require 'rspec/autorun'
    require 'rspec/core/shared_example_group'

    # Requires supporting ruby files with custom matchers and macros, etc,
    # in spec/support/ and its subdirectories.
    #Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

    #require 'mocha/setup'

    RSpec.configure do |config|
      # ## Mock Framework
      #
      # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:

      #config.mock_with :mocha
      #config.mock_with :rspec

      # config.mock_with :flexmock
      # config.mock_with :rr

      # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
      config.fixture_path = "#{::Rails.root}/spec/fixtures"

      # If you're not using ActiveRecord, or you'd prefer not to run each of your
      # examples within a transaction, remove the following line or assign false
      # instead of true.
      config.use_transactional_fixtures = true

      # If true, the base class of anonymous controllers will be inferred
      # automatically. This will be the default behavior in future versions of
      # rspec-rails.
      config.infer_base_class_for_anonymous_controllers = false

      config.treat_symbols_as_metadata_keys_with_true_values = true
      config.filter_run :focus => true
      config.run_all_when_everything_filtered = true
    end

    require 'rspec/matchers'
    require 'rspec/rails/matchers'

    RSpec::configure do |config|
      config.include(Test::Unit::Assertions)
      config.include RSpec::Matchers
      config.include RSpec::Rails::Matchers

      #config.include(Spec::Matchers::HTTP)
    end

    #RSpec::Matchers.define :be_a_multiple_of do |expected|
    #  match do |actual|
    #    actual % expected == 0
    #  end
    #end
  end

  def self.init_unit_spec
    require 'factory_girl_rails'
    enable_factories
    require "#{Rails.root}/spec/support/unit_spec_shared_context"
    #require 'fakeweb'
    #
    #FakeWeb.allow_net_connect = false

    RSpec.configure do |config|
      config.include RSpec::Rails::HelperExampleGroup, :type => :helper, :example_group => { :file_path => /spec\/unit\/helpers/ }
    end
  end

  def self.init_api_spec
    init_spec

    require "#{Rails.root}/spec/support/api_shared_context"
  end

  def self.init_controllers_spec
    require 'factory_girl_rails'
    require "#{Rails.root}/spec/support/controller_spec_shared_context"
  end

  def self.init_requests_spec
    RSpec::configure do |config|
      config.include Webrat::Matchers
      config.include Webrat::Methods
    end
  end

  def self.init_cells_spec
    require 'rspec/rails'
    require 'cell/test_case'
    require 'rspec/rails/example/cell_example_group'
    require "#{Rails.root}/spec/support/cell_spec_shared_context"

    RSpec.configure do |config|
      config.include ActionController::TestCase::Behavior
      config.include RSpec::Rails::ViewRendering

      config.include RSpec::Rails::HelperExampleGroup, :type => :helper, :example_group => { :file_path => /spec\/cells\/helper/ }
    end

    require 'factory_girl_rails'
  end

  def self.init_features_spec
    init_core_spec

    #ENV['DRIVER'] = 'selenium'

    require 'rspec/rails'

    require "#{Rails.root}/spec/features/support/my_acceptance_shared_context"
  end
end
