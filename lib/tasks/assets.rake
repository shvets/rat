namespace :assets do
  ROOT = Rails.root
      #Pathname.new(File.dirname(__FILE__))
  LOGGER = Logger.new(STDOUT)
  APP_ASSETS_DIR = ROOT.join("app/assets")
  PUBLIC_ASSETS_DIR = ROOT.join("vendor/assets")
  OUTPUT_DIR = ROOT.join("#{Rails.root}/public")

  desc 'Compile assets'
  task :compile => :compile_js

  desc 'Compile javascript'
  task :compile_js do
    outfile = Pathname.new(OUTPUT_DIR).join('assets/application.min.js')

    sprockets = Sprockets::Environment.new(ROOT) do |env|
      env.logger = LOGGER
    end

    sprockets.append_path(APP_ASSETS_DIR.join('javascripts').to_s)
    sprockets.append_path(PUBLIC_ASSETS_DIR.join('javascripts').to_s)

    FileUtils.mkdir_p outfile.dirname
    asset = sprockets['application.js']

    asset.write_to(outfile)
    puts "Compiled JS assets"
  end
end