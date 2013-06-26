#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

RailsDemo::Application.load_tasks

require 'interrupt_test'

task :"chef:example" do
  `chef-solo -c config/solo.rb -j config/vagrant-node.json`
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

require 'jasmine-headless-webkit'

Jasmine::Headless::Task.new('jasmine:spec') do |t|
  t.colors = true
  t.keep_on_error = true
  #t.jasmine_config = 'this/is/the/path.yml'
end


