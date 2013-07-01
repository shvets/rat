require 'json'
require 'script_executor/executable'
require 'script_executor/script_locator'

require File.expand_path('common_lib', File.dirname(__FILE__))

class MacbookProvision < Thor
  include Executable, ScriptLocator, FileUtils
  include CommonLib

  attr_reader :config, :script_list, :password

  desc "all", "Installs all required packages"
  def all
    invoke :brew
    invoke :rvm
    invoke :qt

    invoke :mysql
    invoke :mysql_restart

    invoke :postgres
    invoke :postgres_restart

    invoke :jenkins
    invoke :jenkins_restart

    invoke :ruby
  end

  desc "brew", "Installs homebrew"
  def brew
    installed = package_installed "/usr/local/bin/brew"

    install("brew", binding, installed)
  end

  desc "rvm", "Installs rvm"
  def rvm
    installed = package_installed "#{config[:home]}/.rvm/bin/rvm"

    install("rvm", binding, installed)
  end

  desc "qt", "Installs qt"
  def qt
    installed = package_installed "/usr/local/bin/qmake"

    install("qt", binding, installed)
  end

  desc "mysql", "Installs mysql server"
  def mysql
    installed = package_installed "/usr/local/bin/mysql"

    install("mysql", binding, installed)
  end

  # brew uninstall mysql

  desc "mysql_restart", "Restarts mysql server"
  def mysql_restart
    started = service_started("homebrew.mxcl.mysql")

    start("mysql_restart", binding, started)
  end

  desc "postgres", "Installs postgres server"
  def postgres
    installed = package_installed "/usr/local/bin/postgres"

    install("postgres", binding, installed)
  end

  desc "postgres_restart", "Restarts postgres server"
  def postgres_restart
    started = service_started("homebrew.mxcl.postgres")

    start("postgres_restart", binding, started)
  end

  desc "ruby", "Installs ruby"
  def ruby
    installed = package_installed "#{config[:home]}/.rvm/rubies/ruby-1.9.3-p429/bin/ruby"

    if mountain_lion?
      install("ruby_ml", binding, installed)
    elsif snow_leopard?
      install("ruby_sl", binding, installed)
    end
  end

  desc "jenkins", "Installs jenkins server"
  def jenkins
    installed = package_installed "/usr/local/opt/jenkins/libexec/jenkins.war"

    install("jenkins", binding, installed)
  end

  desc "jenkins_restart", "Restart jenkins server"
  def jenkins_restart
    started = service_started("homebrew.mxcl.jenkins")

    start("jenkins_restart", binding, started)
  end

  desc "selenium", "Installs selenium server"
  def selenium
    installed = package_installed "/usr/local/opt/selenium-server-standalone/selenium-server-standalone*.jar"

    install("selenium", binding, installed)
  end

  desc "selenium_restart", "Restarts selenium server"
  def selenium_restart
    started = service_started("homebrew.mxcl.selenium-server-standalone")

    start("selenium_restart", binding, started)
  end

  protected

  def script_list
    @script_list ||= scripts(__FILE__)
  end

  def password
    @password ||= ask_password(config[:user])
  end

  def server_info
    @server_info ||= {
        #remote: localhost?(config[:host]) ? false : true,
        remote: true,
        domain: config[:host],
        user: config[:user],
        #password: localhost?(config[:host]) ? "" : ask_password(config[:user])
        password: "a"
    }
  end

  def read_node node_name
    hash = JSON.parse(File.read(node_name))

    hash.default_proc = proc{|h, k| h.key?(k.to_s) ? h[k.to_s] : nil}

    hash.each do |key, value|
      hash[key] = eval value if value =~ /^ENV\[(.*)\]$/
    end

    hash
  end

  def package_installed package_path
    result = execute(server_info.merge(:suppress_output => true, :capture_output => true)) do
      evaluate_script_body(script_list["package_installed"], binding)
    end

    result.chomp == package_path
  end

  def service_started name
    result = execute(server_info.merge(:suppress_output => true, :capture_output => true)) do
      evaluate_script_body(script_list["service_started"], binding)
    end

    result.chomp.size > 0
  end

  def install script_name, binding, installed=false
    run(script_name, binding) unless installed
  end

  def start script_name, binding, started=false
    run(script_name, binding)
  end

  def run script_name, binding
    execute(server_info) { evaluate_script_body(script_list[script_name], binding) }
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
    execute(server_info) { "/usr/local/bin/dropuser #{app_user}" }
  end

  def create_postgres_schema app_user, schema
    schema_exists = postgres_schema_exist?(schema)

    run("create_postgres_schema", binding)
    #unless schema_exists
  end

  def drop_postgres_schema schema
    execute(server_info) { "/usr/local/bin/dropdb #{schema}" }
  end

end


__END__


[brew]
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"


[rvm]
PATH=$PATH:/usr/local/bin

curl -L https://get.rvm.io | bash

brew update
brew tap homebrew/dupes
brew tap homebrew/versions


[qt]
PATH=$PATH:/usr/local/bin

brew install qt


[package_installed]
PACKAGE_PATH="<%=package_path%>"

ls $PACKAGE_PATH


[service_started]
NAME="<%=name%>"

TEMPFILE="$(mktemp XXXXXXXX)"
launchctl list | grep $NAME > $TEMPFILE
cat $TEMPFILE
rm $TEMPFILE


[mysql]
PATH=$PATH:/usr/local/bin

brew install mysql

mkdir -p <%= config[:home] %>/Library/LaunchAgents

ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents

mysqladmin -u root password 'root'


[mysql_restart]
STARTED=<%=started%>

if [ "$STARTED" = "true" ] ; then
  launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
fi

launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist


[create_mysql_user]
PATH=$PATH:/usr/local/bin

APP_USER='<%= app_user %>'
HOSTNAME='<%= config[:mysql][:hostname] %>'
USER='<%= config[:mysql][:user] %>'
PASSWORD='<%= config[:mysql][:password] %>'

mysql -h $HOSTNAME -u root -p"root" -e "DROP USER '$APP_USER'@'$HOSTNAME';"
mysql -h $HOSTNAME -u root -p"root" -e "CREATE USER '$APP_USER'@'$HOSTNAME' IDENTIFIED BY '$APP_USER';"

mysql -h $HOSTNAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'$HOSTNAME' identified by '$APP_USER' with grant option;"
mysql -h $HOSTNAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'%' identified by '$APP_USER' with grant option;"


[create_mysql_schema]
PATH=$PATH:/usr/local/bin

SCHEMA='<%= schema %>'
HOSTNAME='<%= config[:mysql][:hostname] %>'
USER='<%= config[:mysql][:user] %>'
PASSWORD='<%= config[:mysql][:password] %>'

mysql -h $HOSTNAME -u root -p"root" -e "create database $SCHEMA;"


[postgres]
PATH=$PATH:/usr/local/bin

brew install postgres

ln -sfv /usr/local/opt/postgresql/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents

initdb /usr/local/var/postgres -E utf8


[postgres_restart]
STARTED=<%=started%>

if [ "$STARTED" = "true" ] ; then
  launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
fi

launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


[create_postgres_user]
PATH=$PATH:/usr/local/bin

APP_USER='<%= app_user %>'

createuser -s -d -r $APP_USER


[create_postgres_schema]
PATH=$PATH:/usr/local/bin

APP_USER='<%= app_user %>'
SCHEMA='<%= schema %>'

createdb -U $APP_USER $SCHEMA


[ruby_ml]
PATH=$PATH:/usr/local/bin

rvm autolibs disable
rvm install 1.9.3


[ruby_sl]
PATH=$PATH:/usr/local/bin

rvm autolibs enable
rvm install 1.9.3  --with-gcc=clang


[jenkins]
PATH=$PATH:/usr/local/bin

brew install jenkins

ln -sfv /usr/local/opt/jenkins/homebrew.mxcl.jenkins.plist ~/Library/LaunchAgents


[jenkins_restart]
STARTED=<%=started%>

if [ "$STARTED" = "true" ] ; then
  launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.jenkins.plist
fi

launchctl load ~/Library/LaunchAgents/homebrew.mxcl.jenkins.plist


[selenium]
PATH=$PATH:/usr/local/bin

brew install selenium-server-standalone

ln -sfv /usr/local/opt/selenium-server-standalone/*.plist ~/Library/LaunchAgents


[selenium_restart]
STARTED=<%=started%>

if [ "$STARTED" = "true" ] ; then
  launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist
fi
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist

