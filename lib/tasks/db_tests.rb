require 'shadow_db_credentials/shadow_db_credentials'

namespace :db do
  task :info do
    rails_env = 'production'

    # Read database configuration from secured place
    require 'shadow_db_credentials'
    require "#{ENV['DB_DRIVERS_DIR']}/ojdbc6.jar"

    Rails.logger = Logger.new(STDOUT)

    processor = ShadowDbCredentials.new(ENV['CREDENTIALS_DIR'])

    source = StringIO.new <<-TEXT
      production:
        adapter: oracle_enhanced
        credentials: rails_app_tmpl_oracle_url
    TEXT
    connection_hash = processor.retrieve_configuration rails_env, source

    ActiveRecord::Base.establish_connection(connection_hash)

    adapter = ActiveRecord::Base.connection
    connection = adapter.raw_connection

    if connection.respond_to? :meta_data
      meta_data = connection.meta_data

      puts "=====  Database info ====="
      puts "DatabaseProductName: #{meta_data.database_product_name}"
      puts "DatabaseProductVersion: #{meta_data.database_product_version}"
      puts "DatabaseMajorVersion: #{meta_data.database_major_version}"
      puts "DatabaseMinorVersion: #{meta_data.database_minor_version}"
      puts "=====  Driver info ====="
      puts "DriverName: #{meta_data.driver_name}"
      puts "DriverVersion: #{meta_data.driver_version}"
      puts "DriverMajorVersion: #{meta_data.driver_major_version}"
      puts "DriverMinorVersion: #{meta_data.driver_minor_version}"
    end
  end

  task :test1 do
    rails_env = "production"

    require 'shadow_db_credentials'
    require "#{ENV['DB_DRIVERS_DIR']}/ojdbc6.jar"

    processor = ShadowDbCredentials.new(ENV['CREDENTIALS_DIR'])
    connection_hash = processor.retrieve_configuration rails_env

    # 1 ruby syntax for java class name
    #Java::OracleJdbcDriver::OracleDriver

    # 2 Use the thread context class loader
    java.lang.Class.for_name("oracle.jdbc.driver.OracleDriver", true,
                             java.lang.Thread.currentThread.getContextClassLoader)

    connection = java.sql.DriverManager.getConnection(connection_hash['url'], connection_hash['username'],
                                               connection_hash['password'])
    statement = connection.create_statement

    result_set = statement.execute_query("select BANNER from SYS.V_$VERSION")

    while result_set.next
      puts result_set.getObject(1) # get first column
    end

    result_set.close
  end

  task :test2 do
    rails_env = "production"

    require 'shadow_db_credentials'
    require "#{ENV['DB_DRIVERS_DIR']}/ojdbc6.jar"

    processor = ShadowDbCredentials.new(ENV['CREDENTIALS_DIR'])
    connection_hash = processor.retrieve_configuration rails_env

    ActiveRecord::Base.establish_connection(connection_hash
    #:adapter => 'jdbc',
    #    :driver => 'oracle.jdbc.driver.OracleDriver',
    #    :url => 'jdbc:oracle:thin:@myhost:1521:mydb',
    #    :username=>'myuser',
    #    :password=>'mypassword'
    )

    hash = ActiveRecord::Base.connection.execute("select BANNER from SYS.V_$VERSION")

    puts hash
  end

end

