require File.expand_path('../boot', __FILE__)

require 'rails/all'
#require 'shadow_db_credentials/shadow_db_credentials'
require 'zip_dsl'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module RailsDemo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/view_classes)

    def config.database_configuration
      result = super

      #orig_db_configurations = super
      #
      #processor = ShadowDbCredentials.new(ENV['CREDENTIALS_DIR'])
      #
      #result = processor.process_configuration(orig_db_configurations, Rails.env)

      #Rails.logger.warn("1************** #{Rails.env}")
      #Rails.logger.warn(result[Rails.env])
      #
      #result[Rails.env].delete("url")
      #result[Rails.env].delete("username")
      #result[Rails.env].delete("password")
      #
      #Rails.logger.warn("2**************")
      #Rails.logger.warn(result[Rails.env])

      result
    end
  end
end
