class Jboss < Thor
  attr_reader :server

  def initialize *args
    jboss_version   = "6.1.0.Final"
    app_server_home = "#{ENV['HOME']}/jboss-#{jboss_version}"
    deploy_dir      = "#{app_server_home}/server/default/deploy"

    project_name = "rails_app_tmpl"
    warfile = "build2/#{project_name}.war"

    logfile = "#{app_server_home}/server/default/log/server.log"

    @server = JBossServer.new(:app_server_home => app_server_home, :deploy_dir => deploy_dir,
                             :project_name => project_name, :warfile => warfile, :logfile => logfile)
    super
  end

  [:fix, :clean, :start, :stop, :deploy].each do |command|
    if command == :start
      env = " -Xdebug -Xrunjdwp:transport=dt_socket,address=50514,suspend=n,server=y"
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
    invoke :"project:clean"
    invoke :"project:prepare"
    invoke :"project:war"

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


#namespace :jboss do
#  jboss_version   = "6.1.0.Final"
#  app_server_home = "#{ENV['HOME']}/jboss-#{jboss_version}"
#  deploy_dir      = "#{app_server_home}/server/default/deploy"
#
#  task :init do
#    builder.configure
#
#    ds_file_name = case builder.config[:rails_env]
#                     when 'development'
#                       "postgres-ds.xml"
#                     when 'production'
#                       "oracle-ds.xml"
#                     else
#                       "mysql-ds.xml"
#                   end
#
#    ENV['RAILS_ENV'] = builder.config[:rails_env]
#
#    project_name = builder.config[:project_name]
#    warfile = "build/#{project_name}.war"
#
#    logfile = "#{app_server_home}/server/default/log/server.log"
#    datasource_file_name = "#{builder.build_dir}/#{ds_file_name}"
#
#    server = JbossServer.new(:app_server_home => jboss_home, :deploy_dir => deploy_dir,
#                             :project_name => project_name, :datasource_file_name => datasource_file_name,
#                             :warfile => warfile, :logfile => logfile)
#  end
#
#  [:fix, :clean, :start, :stop, :deploy].each do |command|
#    env = nil
#    if command == :start
#      env = " -Xdebug -Xrunjdwp:transport=dt_socket,address=50514,suspend=n,server=y"
#    end
#
#    task(command) do
#      Rake::Task[:"jboss:init"].invoke
#
#      if command == :start
#        server.execute command, env
#      else
#        server.execute command
#      end
#    end
#  end
#
#  task :redeploy => [:"project:war:all", :clean, :deploy]
#
#  task :all => [:"project:war:all", :stop, :clean, :deploy, :start]
#
#  task :restart => [:stop, :start]
#end