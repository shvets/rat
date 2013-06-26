require 'server_launcher'

class Tomcat < Thor
  attr_reader :server

  def initialize *args
    tomcat_version = "7.0.41"
    app_server_home = "/usr/local/Cellar/tomcat/#{tomcat_version}/libexec"
    deploy_dir = "#{app_server_home}/webapps"

    project_name = "rails_app_tmpl"
    #warfile = "target/#{project_name}.war"
    warfile = "#{project_name}.war"

    logfile = "#{app_server_home}/logs/tomcat.log"

    @server = TomcatServer.new(:app_server_home => app_server_home, :deploy_dir => deploy_dir,
                               :project_name => project_name, :warfile => warfile, :logfile => logfile)
    super
  end

  [:fix, :clean, :start, :stop, :deploy].each do |command|
    if command == :start
      ENV['TNS_ADMIN']="/usr/local/oracle/network/admin"
      env = " -Xdebug -Xrunjdwp:transport=dt_socket,address=56906,suspend=n,server=y"
    end

    desc "#{command}", "#{command}"
    define_method(command) do
      if command == :start
        server.execute command, env
      else
        server.execute command
      end
    end
  end

  desc "all", "all"
  def all
    #invoke :"project:clean"
    #invoke :"project:prepare"
    #invoke :"project:war"

    invoke :stop
    invoke :clean
    invoke :deploy
    invoke :start
  end

  desc "restart", "restart"
  def restart
    invoke :stop
    invoke :start
  end

end
