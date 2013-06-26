require 'file_utils'
require 'meta_methods'

class Builder < Thor
  include FileUtils
  include MetaMethods

  attr_reader :builder

  def initialize *args
    require 'web_app_builder/web_app_builder'
    require 'server_launcher'
    require 'zip/zip'

    require File.expand_path('../../config/initializers/env_variables', __FILE__)

    basedir = File.expand_path("#{File.dirname(__FILE__)}/..")

    @builder = WebAppBuilder.new("#{basedir}/build", basedir, gemset_name)

    super
  end

  desc "Cleans the project", "clean"
  def clean
    # puts `rm -Rf build`
    builder.clean
    puts
  end

  desc "Cleans the project", "clean"
  def prepare
    builder.configure
    ENV['RAILS_ENV'] = builder.config[:rails_env]

    builder.prepare
      #puts `mv build/oracle_jndi.yml config`
      #puts
  end

  desc "war", "war"
  def war
    invoke :prepare

    builder.war
    puts
  end

  desc "war_exploded", "war_exploded"
  def war_exploded
    invoke :prepare

    builder.war_exploded
    puts
  end

  desc "war_all", "war_all"
  def war_all
    invoke :clean
    invoke :war
  end

  desc "exploded_all", "exploded_all"
  def exploded_all
    invoke :clean
    invoke :war_exploded
  end

  desc "warble", "warble"
  def warble
    system "warble"

    config = locals_to_hash(self, read_file("Warfile"))

    FileUtils.mkdir_p "build2/META-INF"
    FileUtils.mkdir_p "build2/WEB-INF"

    write_content_to_file(execute_template("config/templates/META-INF/context.xml", binding), "build2/META-INF/context.xml")
    write_content_to_file(execute_template("config/templates/META-INF/init.rb", binding), "build2/META-INF/init.rb")
    write_content_to_file(execute_template("config/templates/WEB-INF/web.xml", binding), "build2/WEB-INF/web.xml")

    Zip::ZipFile.open("rails_app_tmpl.war") do |zipfile|
      zipfile.add("META-INF/context.xml", "build2/META-INF/context.xml")
      zipfile.replace("META-INF/init.rb", "build2/META-INF/init.rb")
      zipfile.replace("WEB-INF/web.xml", "build2/WEB-INF/web.xml")
    end
  end

  private

  def gemset_name
    File.open(".ruby-gemset").read.chomp
  end

end if RUBY_PLATFORM == "java"
