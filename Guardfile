# A sample Guardfile
# More info at https://github.com/guard/guard#readme

#ignore_paths 'public'

group :backend do
  guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('Gemfile')
    watch('Gemfile.lock')
    watch('spec/spec_helper.rb')
    watch('test/test_helper.rb')
    watch('spec/factories.rb')
    watch('spec/support/spec_conf.rb')
  end

  guard :bundler do
    watch('Gemfile')
  end

  guard 'rspec', :version => 2, :all_on_start => false, :all_after_pass => false, :cli => "--drb" do
    # top level
    watch('spec/spec_helper.rb') { "spec" }
    watch(%r{^spec/support/.+\.rb$}) { "spec" }
    watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
    watch('config/routes.rb') { "spec/routing" }

    # acceptance
    #watch('spec/acceptance/selenium_spec_helper.rb')  {}
    #watch('spec/acceptance/capybara/capybara_selenium_spec_helper.rb')  {}
    #watch(%r{^spec/acceptance/capybara/.+_spec\.rb$})  {}
    #watch(%r{^spec/acceptance/mechanize/.+_spec\.rb$})  {}
    #watch(%r{^spec/acceptance/selenium/.+_spec\.rb$})  {}
    #watch(%r{^spec/acceptance/.+_spec\.rb$}) { puts "hello" }

    # cells
    watch('spec/cells/cell_spec_helper.rb')  { "spec/cells" }
    watch(%r{^spec/cells/helpers/.+_spec\.rb$})
    watch(%r{^spec/cells/.+_spec\.rb$})

    # controllers
    watch('spec/controllers/controller_spec_helper.rb')  { "spec/cells" }
    watch(%r{^spec/controllers/.+_spec\.rb$})

    # unit
    watch('spec/unit/unit_spec_helper.rb') { "spec/unit" }
    watch(%r{^spec/unit/.+_spec\.rb$}) { "spec/unit" }

    #watch(%r{^spec/.+_spec\.rb$}) { `say hello` }
    #watch(%r{^spec/.+\.rb$}) { `say hello` }

    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }

    watch(%r{^spec/models/.+\.rb$}) { "spec/models" }

    ## Rails example
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }

    ## Capybara request specs
    #watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
  end
end

group :frontend do
  #guard :coffeescript, :input => 'coffeescripts', :output => 'javascripts'

  #guard :livereload do
  #  watch(%r{^app/.+\.(erb|haml)$})
  #end
end


