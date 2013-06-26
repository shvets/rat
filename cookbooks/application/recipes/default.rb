class AppCookbook
  attr_reader :context

  def initialize context
    @context = context
  end

  def install_common_packages
    context.include_recipe "apt"

    context.package "curl"
    context.package "g++"
    context.package "subversion"
    context.package "debconf-utils"
  end

  def install_rvm
    context.include_recipe "rvm"

    context.bash "Registering RVM" do
      code "source /etc/profile.d/rvm.sh"

      not_if "test -e /usr/local/rvm/bin/rvm"
    end

    context.bash "Configuring RVM" do
      user "root"

      code <<-CODE
chown -R vagrant /usr/local/rvm
/usr/local/rvm/bin/rvm autolibs enable
      CODE
    end

    context.include_recipe "rvm::install"
  end

  def install_postgres postgres_user, postgres_password
    context.include_recipe "postgresql"
    context.include_recipe "postgresql::server"

    context.bash "Assigning password for postgres user" do
      code "sudo usermod --password #{postgres_user} #{postgres_password}"
    end
  end

  def create_postgres_user postgres_user, app_user, db_schema
      context.bash "Creating postgres db user" do
      user "postgres"

      code <<-CODE
psql -c "CREATE USER #{app_user} WITH PASSWORD '#{app_user}'"
      CODE

      not_if { `sudo sudo -u #{postgres_user} psql -c '\\l'`.include?(db_schema) }
    end
  end

  def create_postgres_database db_schema, postgres_user, app_user
    encoding_string = "WITH ENCODING = 'UTF-8' LC_CTYPE = 'en_US.utf8' LC_COLLATE = 'en_US.utf8' OWNER #{postgres_user} TEMPLATE template0"

    context.bash "Creating postgres database: #{db_schema}" do
      user "postgres"

      code <<-CODE
psql -c "CREATE DATABASE #{db_schema} #{encoding_string}"
psql -c "GRANT ALL PRIVILEGES ON DATABASE  #{db_schema} to #{app_user}"
      CODE

      not_if { `sudo sudo -u postgres psql -c '\\l'`.include?(db_schema) }
    end
  end

  def install_mysql mysql_server_version, mysql_password
    context.include_recipe "mysql"
    context.include_recipe "mysql::server"

    context.bash "Setting up password for mysql root user" do
      user 'root'

      code <<-CODE
debconf-set-selections <<< "mysql-server-#{mysql_server_version} mysql-server/root_password password #{mysql_password}"
debconf-set-selections <<< "mysql-server-#{mysql_server_version} mysql-server/root_password_again password #{mysql_password}"
      CODE
    end
  end

  def create_mysql_user mysql_user, mysql_password, mysql_hostname, app_user
    context.bash "Creating mysql user" do
      code <<-CODE
mysql -h #{mysql_hostname} -u #{mysql_user} -p"#{mysql_password}" -e "CREATE USER '#{app_user}'@'#{mysql_hostname}' IDENTIFIED BY '#{app_user}';"
mysql -h #{mysql_hostname} -u #{mysql_user} -p"#{mysql_password}" -e "GRANT ALL PRIVILEGES ON *.* TO '#{app_user}'@'#{mysql_hostname}' identified by '#{app_user}' WITH GRANT OPTION;"
      CODE

      #not_if { `mysql -h #{mysql_hostname} -u #{mysql_user} -p"#{mysql_password}" -e "SELECT * FROM mysql.user;"`.include?(app_user) }
    end
  end

  def create_mysql_database db_schema, mysql_user, mysql_password, mysql_hostname
    context.bash "Creating mysql database: #{db_schema}" do
      code <<-CODE
mysql -h #{mysql_hostname} -u #{mysql_user} -p"#{mysql_password}" -e "create database #{db_schema};"
      CODE

      not_if { `mysql -h #{mysql_hostname} -u #{mysql_user} -p"#{mysql_password}" -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA;"`.include?(db_schema) }
    end
  end

  def install_project app_home, ruby_version, gem_name
    context.bash "Installing bundle" do
      user 'vagrant'
      cwd app_home

      code <<-CODE
source /etc/profile.d/rvm.sh
rvm use #{ruby_version}@#{gem_name} --create
bundle install --without=production
      CODE
    end

#bash "Project db bootstrap" do
#  user 'vagrant'
#
#  cwd app_home
#  #environment(node[:rails][:bash_env])
#  code <<-CODE
#    source /etc/profile.d/rvm.sh
#
#    rake db:create:all
#    rake db:migrate
#    rake db:test:prepare
#  CODE
#end
  end

end

ruby_version = 'ruby-1.9.3-p392'
gem_name = "rails_app_tmpl"
mysql_server_version = '5.0'

mysql_user = 'root'
mysql_password = 'root'
mysql_hostname = 'localhost'

postgres_user = 'postgres'
postgres_password = 'postgres'

app_user = 'rails_app_tmpl'
app_home = '/vagrant'

test_db_schema = 'rails_app_tmpl_test'
dev_db_schema = 'rails_app_tmpl_dev'
prod_db_schema = 'rails_app_tmpl_prod'

book = AppCookbook.new self

book.install_common_packages

book.install_rvm

book.install_postgres postgres_user, postgres_password

book.create_postgres_user postgres_user, app_user, dev_db_schema

book.create_postgres_database test_db_schema, postgres_user, app_user
book.create_postgres_database dev_db_schema, postgres_user, app_user
book.create_postgres_database prod_db_schema, postgres_user, app_user

book.install_mysql mysql_server_version, mysql_password

book.create_mysql_database test_db_schema, mysql_user, mysql_password, mysql_hostname
book.create_mysql_database dev_db_schema, mysql_user, mysql_password, mysql_hostname
book.create_mysql_database prod_db_schema, mysql_user, mysql_password, mysql_hostname

book.install_project app_home, ruby_version, gem_name

# rake db:migrate
# rails s
