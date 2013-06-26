require File.expand_path('../boot', __FILE__)

require 'rails/all'
#require 'shadow_db_credentials/shadow_db_credentials'
require 'zip_dsl'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line

  groups = {
    :current => %W(default #{Rails.env})
  }

  Bundler.require(*Rails.groups(*groups[:current]))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module RailsDemo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/view_classes)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

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
