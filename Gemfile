source 'https://rubygems.org'

#bundle install --path .bundle/gems --binstubs .bundle/bin

require './gemfile_helper'

Bundler::Dsl.send :include, GemfileHelper

group :default do
  gem "rails"

  gem 'json'
  gem 'nokogiri'
  gem 'jquery-rails'
  gem "shadow_db_credentials"
  gem "zip_dsl"

  gem "pg", '0.13.2'
  gem 'mysql', "2.8.1"
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyrhino'

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  if not (RUBY_PLATFORM =~ /linux/)
    gem "sqlite3", "1.3.6"
  end

  gem "rspec"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "mocha", :require => false
  gem "tiny-cms"

  gem "spork"

  gem 'cucumber-rails', :require => false
  gem "rspec-example_steps"

  gem "web_app_builder"
  gem 'fivemat'

  #gem "guard"
  #gem "guard-rspec"
  #gem "guard-spork"
  #gem "guard-bundler"
  #gem "guard-coffeescript", "0.5.4"
  #gem "guard-livereload", "0.4.0"
  #gem "pry", "0.9.8.2"
end

group :tools do
  gem "rake"
  gem "foreman"
  #gem "heroku"
  gem "thor"
  gem "rubyzip"
  gem "script_executor"
  gem "aspector"
  gem "server_launcher"

  gem "lunchy" if mac?
end

group :servers do
  gem "thin"
end

group :production do

  #ENV['DYLD_LIBRARY_PATH'] ||= "/usr/local/oracle/instantclient_11_2"
  #gem "ruby-oci8", "2.1.5"
end

group :provision do
  gem "chef"
  gem "librarian-chef"
  #gem "knife-solo", ">= 0.3.0pre3"
  #gem "berkshelf"
end

group :debug do
  gem "ruby-debug-base19x", "0.11.30.pre12"
  gem "ruby-debug-ide", "0.4.17"
end

group :acceptance_test do
  gem "acceptance_test"
  gem "capybara", "2.1.0"

  gem "capybara-webkit", "1.0.0"
  #gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'

  # Note: You need to install qt:
  # Mac: brew install qt
  # Ubuntu: sudo apt-get install libqt4-dev libqtwebkit-dev
  # Debian: sudo apt-get install libqt4-dev
  # Fedora: yum install qt-webkit-devell

  #gem "capybara-firebug"
  gem "poltergeist" # brew install phantomjs

  gem "selenium-webdriver"
end

group :test_tools do
  gem "spork"
  gem "guard"
  gem "guard-rspec"
  gem "guard-spork"
  gem "guard-bundler"
  #gem "guard-coffeescript", "0.5.4"
  #gem "guard-livereload", "0.4.0"
  #gem "pry", "0.9.8.2"
end

group :presentation do
  gem "rmagick"
  gem "pdf-inspector"
  gem "pdfkit"
  gem "wkhtmltopdf-binary", '0.9.5.3'
  # http://hocuspokus.net/2010/03/installing-rmagick-on-snow-leopard-leopard/
  # git clone git://github.com/masterkain/ImageMagick-sl.git
  # cd ImageMagick-sl
  # sh install_im.sh

  gem "parade"
  #gem "parade-liveruby"
end