#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

RailsDemo::Application.load_tasks

require 'interrupt_test'

task :"chef:example" do
  `chef-solo -c config/solo.rb -j config/vagrant-node.json`
end

task :fix_debug do
  system "mkdir -p $GEM_HOME/gems/debugger-ruby_core_source-1.2.3/lib"
  system "cp -R ~/debugger-ruby_core_source/lib $GEM_HOME/gems/debugger-ruby_core_source-1.2.3"
end

