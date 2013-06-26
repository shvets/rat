require 'script_executor/executable'

class OracleClient < Thor
  include Executable

  attr_reader :env

  def initialize *params
    configure

    super *params
  end

  desc "install", "install"
  def install
    install_instant_client
  end

  desc "test", "test"
  def test
    test_installation
  end

  desc "remove_install", "remove_install"
  def remove_install
    execute(:sudo => true)  do
      %Q(
        echo "Removing Oracle instant client..."

        RUBY_HOME="#{env[:ruby_home]}"

        rm -rf #{env[:client_install_dir]}

        rm $RUBY_HOME/lib/ruby/site_ruby/1.8/oci8.rb
        #rm -rf $RUBY_HOME/lib/ruby/site_ruby/1.8/oci8
      )
    end
  end

  private

  def configure
    @env = {}

    @env[:ruby_home] = "#{ENV['HOME']}/.rvm/rubies/ruby-1.9.3-p392"
    @env[:logname]   = execute(:script => "logname", :capture_output => true)

    @env[:oracle_base]      = "/usr/local/oracle"
    @env[:oracle_version]   = "11.2.0.3.0"
    @env[:ruby_oci_version] = "2.1.5"

    @env[:instant_client_name] = "instantclient_11_2"
    @env[:installs_dir]       = "#{ENV['HOME']}/work/dev_contrib/installs"
    @env[:client_distr_dir]   = "#{@env[:installs_dir]}/oracle-client"
    @env[:client_install_dir] = "#{@env[:oracle_base]}/instantclient_11_2"
    @env[:tnsnames_dir]       = "#{@env[:oracle_base]}/network/admin"

    puts "oracle_version: #{env[:oracle_version]}"
    puts "ruby_oci_version: #{env[:ruby_oci_version]}"
  end

  def install_instant_client
    execute(:sudo => true, :capture_output => true)  do
      copy_instant_client
    end

    #+
    #compile_ruby_oci8
  end

  def copy_instant_client
    from_dir = env[:client_distr_dir]
    to_dir   = env[:oracle_base]

    %Q(
        echo "Creating required directories for Oracle instant client..."

        mkdir -p #{to_dir}
        mkdir -p #{env[:tnsnames_dir]}
        mkdir -p #{env[:client_install_dir]}

        echo "Unzipping Oracle instant client..."
        echo "#{from_dir}/instantclient-basic-macos.x64-#{env[:oracle_version]}.zip"

        cp #{from_dir}/instantclient-basic-macos.x64-#{env[:oracle_version]}.zip #{to_dir}
        cp #{from_dir}/instantclient-sdk-macos.x64-#{env[:oracle_version]}.zip #{to_dir}
        cp #{from_dir}/instantclient-sqlplus-macos.x64-#{env[:oracle_version]}.zip #{to_dir}

        unzip -o #{to_dir}/instantclient-basic-macos.x64-#{env[:oracle_version]}.zip -d #{to_dir}
        unzip -o #{to_dir}/instantclient-sdk-macos.x64-#{env[:oracle_version]}.zip -d #{to_dir}
        unzip -o #{to_dir}/instantclient-sqlplus-macos.x64-#{env[:oracle_version]}.zip -d #{to_dir}

        echo "Creating soft links..."

        ln -sF #{env[:client_install_dir]}/libclntsh.dylib.11.1 #{env[:client_install_dir]}/libclntsh.dylib
        #ln -sF #{env[:client_install_dir]}/libocci.dylib.11.1 #{env[:client_install_dir]}/libocci.dylib
      )
  end

  def compile_ruby_oci8
    dir = "#{env[:client_distr_dir]}/ruby-oci8-#{env[:ruby_oci_version]}"

    %Q(
        RUBY_HOME="#{env[:ruby_home]}"
        RUBY="#{env[:ruby_home]}/bin/ruby"
        ORACLE_BASE="#{env[:oracle_base]}"
        MY_USER=#{env[:logname]}

        #export DYLD_LIBRARY_PATH

        echo "Unziping Oracle oci8 driver for Ruby..."

        tar xvzf #{env[:client_distr_dir]}/ruby-oci8-#{env[:ruby_oci_version]}.tar.gz -C #{env[:client_distr_dir]}

        echo "Building and Installing Oracle oci8 driver for Ruby..."

        #rm $RUBY_HOME/lib/ruby/site_ruby/1.8/oci8.rb
        #rm -rf $RUBY_HOME/lib/ruby/site_ruby/1.8/oci8

        echo "Compiling ruby-oci gem..."

        cd #{dir}

        DYLD_LIBRARY_PATH="$ORACLE_BASE/#{env[:instant_client_name]}" TNS_ADMIN="$ORACLE_BASE/network/admin" \
          $RUBY setup.rb config
        DYLD_LIBRARY_PATH="$ORACLE_BASE/#{env[:instant_client_name]}" TNS_ADMIN="$ORACLE_BASE/network/admin" \
          $RUBY setup.rb setup
        DYLD_LIBRARY_PATH="$ORACLE_BASE/#{env[:instant_client_name]}" TNS_ADMIN="$ORACLE_BASE/network/admin" $RUBY \
          setup.rb install

        #chown -R #{env[:logname]} $RUBY_HOME/lib/ruby/site_ruby/1.8/oci8
      )
  end

end

