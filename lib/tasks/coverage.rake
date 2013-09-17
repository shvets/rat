namespace :coverage do
  require 'simplecov'
  require 'simplecov-html'

  desc 'Sets up coverage build - call it before rspec:all'
  task :setup do
    Rake::Task[:environment].invoke

    profile = build_profile

    SimpleCov.start profile

    load_project
  end

  private

  def build_profile
    profile = 'neptune_rails'

    register_profile profile

    SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

    SimpleCov.at_exit do
      SimpleCov.result.format!
    end

    profile
  end

  def register_profile profile
    SimpleCov.adapters.define profile do
      add_group "Domain", "app/domain"
      add_group "Helpers", "app/helpers"
      add_group "Controllers", "app/controllers"
      add_group "Models", "app/models"

      add_filter '/spec/*'
      #add_filter '/test/*'
      add_filter '/db/*'
      add_filter 'lib/tasks/*'

      #add_filter "#{ENV['GEM_HOME']}/*"
      #add_filter 'vendor/gems/*'
      #add_filter 'vendor/plugins/*'
      #add_filter 'tools/*'
    end
  end

  def load_project
    # require all ruby files
    Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
  end
end
