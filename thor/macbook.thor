require 'script_executor/executable'
require 'script_executor/script_locator'

require File.expand_path('common_lib', File.dirname(__FILE__))

class Macbook < Thor
  include Executable, ScriptLocator, FileUtils
  include CommonLib

  attr_reader :config, :script_list

  private

  def config
    @config ||= {
      :host => "localhost",
      :user => ENV['USER'],
      :home => ENV['HOME'],
      :mysql => {
        :hostname => "localhost", :user => "root", :password => "root"
      },
      :postgres => {
        :hostname => "localhost", :user => "rails_app_tmpl", :password => "rails_app_tmpl"
      }
    }
  end

  def script_list
    @script_list ||= scripts(__FILE__)
  end

  def server_info
    @server_info ||= {
      :remote => (config[:host] == 'localhost') ? false : true,
      :domain => config[:host],
      :user =>  config[:user],
      :password => (config[:host] == 'localhost') ? "" : ask_password(config[:user])
    }
  end

  public

  def initialize *args
    config

    super
  end

  desc "all", "Installs all required packages"
  def all
    invoke :hb
    invoke :rvm
    invoke :qt

    invoke :mysql
    invoke :mysql_restart

    invoke :postgres
    invoke :postgres_restart

    invoke :ruby

    invoke :jenkins
    invoke :jenkins_restart

    invoke :mysql_create
    invoke :postgres_create
  end

  desc "hb", "Installs homebrew"
  def hb
    installed = package_installed brew

    run("hb", binding, installed)
  end

  desc "rvm", "Installs rvm"
  def rvm
    installed = package_installed "#{config[:home]}/.rvm/bin/rvm"

    run("rvm", binding, installed)
  end

  desc "qt", "Installs qt"
  def rvm
    installed = package_installed "/usr/local/bin/qmake"

    run("qt", binding, installed)
  end

  desc "mysql", "Installs mysql server"
  def mysql
    installed = package_installed "/usr/local/bin/mysql"

    run("mysql", binding, installed)
  end

  desc "mysql_restart", "Restarts mysql server"
  def mysql_restart
    run("mysql_restart", binding)
  end

  desc "postgres", "Installs postgres server"
  def postgres
    installed = package_installed "/usr/local/bin/postgres"

    run("postgres", binding, installed)
  end

  desc "postgres_restart", "Restarts postgres server"
  def postgres_restart
    run("postgres_restart", binding)
  end

  desc "ruby", "Installs ruby"
  def ruby
    installed = package_installed "#{config[:home]}/.rvm/rubies/ruby-1.9.3-p429/bin/ruby"

    unless installed
      if mountain_lion?
        run("ruby_ml", binding, installed)
      elsif snow_leopard?
        run("ruby_sl", binding, installed)
      end
    end
  end

  desc "jenkins", "Installs jenkins server"
  def jenkins
    installed = package_installed "/usr/local/opt/jenkins/libexec/jenkins.war"

    run("jenkins", binding, installed)
  end

  desc "jenkins_restart", "Restart jenkins server"
  def jenkins_restart
    run("jenkins_restart", binding)
  end

  desc "selenium", "Installs selenium server"
  def selenium
    run("selenium", binding, installed)
  end

  desc "selenium_restart", "Restarts selenium server"
  def selenium_restart
    run("selenium_restart", binding, installed)
  end

  desc "mysql_create", "Initializes mysql project schemas"
  def mysql_create
    create_mysql_user "rails_app_tmpl"

    create_mysql_schema "rails_app_tmpl_test"
    create_mysql_schema "rails_app_tmpl_dev"
    create_mysql_schema "rails_app_tmpl_prod"
  end

    desc "mysql_test", "Test mysql schemas"
  def mysql_test
    result = get_mysql_schemas config[:mysql][:hostname], config[:mysql][:user], config[:mysql][:password], "rails_app_tmpl_test"

    puts result
  end

  desc "postgres_test", "Test postgres schemas"
  def postgres_test
    result = get_postgres_schemas "rails_app_tmpl_test"

    puts result
  end

  desc "postgres_create", "Initializes postgres project schemas"
  def postgres_create
    create_postgres_user "rails_app_tmpl", "rails_app_tmpl_test"

    create_postgres_schema "rails_app_tmpl", "rails_app_tmpl_test"
    create_postgres_schema "rails_app_tmpl", "rails_app_tmpl_dev"
    create_postgres_schema "rails_app_tmpl", "rails_app_tmpl_prod"
  end

  desc "postgres_drop", "Drops postgres project schemas"
  def postgres_drop
    drop_postgres_schema "rails_app_tmpl_test"
    drop_postgres_schema "rails_app_tmpl_dev"
    drop_postgres_schema "rails_app_tmpl_prod"

    drop_postgres_user "rails_app_tmpl", "rails_app_tmpl_test"
  end

  private

  def run script_name, binding, installed=false
    execute(server_info) { evaluate_script_body(script_list[script_name], binding) } unless installed
  end

  def package_installed package_path
    result = execute(server_info.merge(:suppress_output => true, :capture_output => true, :script => "ls #{package_path}"))

    result.chomp == package_path
  end

  def mysql_schema_exist?(hostname, user, password, schema)
    get_mysql_schemas(hostname, user, password, schema).include?(schema)
  end

  def get_mysql_schemas hostname, user, password, schema
    cmd = "/usr/local/bin/mysql -h #{hostname} -u #{user} -p\"#{password}\" -e \"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA;\""

    execute(server_info.merge(:suppress_output => true, :capture_output => true, :script => cmd))
  end

  def postgres_schema_exist?(schema)
    get_postgres_schemas(schema).include?(schema)
  end

  def get_postgres_schemas schema
    cmd = "/usr/local/bin/psql -d #{schema} -c '\\l'"

    execute(server_info.merge(:suppress_output => true, :capture_output => true, :script => cmd))
  end

  def create_mysql_user app_user
    run("create_mysql_user", binding)
  end

  def create_mysql_schema schema
    schema_exists = mysql_schema_exist?(config[:mysql][:hostname], config[:mysql][:user], config[:mysql][:password], schema)

    run("create_mysql_schema", binding)
    #unless schema_exists
  end

  def create_postgres_user app_user, schema
    schema_exists = postgres_schema_exist?(schema)

    run("create_postgres_user", binding)
    #unless schema_exists
  end

  def drop_postgres_user app_user, schema
    execute(server_info) { "dropuser #{app_user}" }
  end

  def create_postgres_schema app_user, schema
    schema_exists = postgres_schema_exist?(schema)

    run("create_postgres_schema", binding)
    #unless schema_exists
  end

  def drop_postgres_schema schema
    execute(server_info) { "dropdb #{schema}" }
  end

end


__END__


[hb]
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"


[rvm]
source ~/.bash_profile

curl -L https://get.rvm.io | bash

brew update
brew tap homebrew/dupes
brew tap homebrew/versions


[qt]
source ~/.bash_profile

brew install qt


[mysql]
source ~/.bash_profile

brew install mysql

mkdir -p <%= config[:home] %>/Library/LaunchAgents

ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents

mysqladmin -u root password 'root'


[mysql_restart]
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

[create_mysql_user]
source ~/.rvm/scripts/rvm

APP_USER='<%= app_user %>'
HOSTNAME='<%= config[:mysql][:hostname] %>'
USER='<%= config[:mysql][:user] %>'
PASSWORD='<%= config[:mysql][:password] %>'

mysql -h $HOSTNAME -u root -p"root" -e "DROP USER '$APP_USER'@'$HOSTNAME';"
mysql -h $HOSTNAME -u root -p"root" -e "CREATE USER '$APP_USER'@'$HOSTNAME' IDENTIFIED BY '$APP_USER';"

mysql -h $HOSTNAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'$HOSTNAME' identified by '$APP_USER' with grant option;"
mysql -h $HOSTNAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'%' identified by '$APP_USER' with grant option;"


[create_mysql_schema]
source ~/.rvm/scripts/rvm

SCHEMA='<%= schema %>'
HOSTNAME='<%= config[:mysql][:hostname] %>'
USER='<%= config[:mysql][:user] %>'
PASSWORD='<%= config[:mysql][:password] %>'

mysql -h $HOSTNAME -u root -p"root" -e "create database $SCHEMA;"


[postgres]
source ~/.bash_profile

brew install postgres

ln -sfv /usr/local/opt/postgresql/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents

initdb /usr/local/var/postgres -E utf8


[postgres_restart]
launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


[create_postgres_user]
source ~/.rvm/scripts/rvm

APP_USER='<%= app_user %>'

createuser -s -d -r $APP_USER


[create_postgres_schema]
source ~/.rvm/scripts/rvm

APP_USER='<%= app_user %>'
SCHEMA='<%= schema %>'

createdb -U $APP_USER $SCHEMA


[ruby_ml]
source ~/.bash_profile

rvm autolibs disable
rvm install 1.9.3


[ruby_sl]
source ~/.bash_profile

rvm autolibs enable
rvm install 1.9.3  --with-gcc=clang


[jenkins]
source ~/.bash_profile

brew install jenkins

ln -sfv /usr/local/opt/jenkins/homebrew.mxcl.jenkins.plist ~/Library/LaunchAgents


[jenkins_restart]
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.jenkins.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.jenkins.plist


[selenium]
source ~/.bash_profile

brew install selenium-server-standalone

ln -sfv /usr/local/opt/selenium-server-standalone/*.plist ~/Library/LaunchAgents


[selenium_restart]
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist

