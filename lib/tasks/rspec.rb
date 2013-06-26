namespace :spec do
  require 'rspec/core/rake_task'

  def create_spec_task name, paths
    pattern = paths.collect {|path| "spec/#{path}/**/*_spec.rb" }.join(", ")

    RSpec::Core::RakeTask.new(name) do |task|
      Rake.application.last_description = ("Run the code examples in spec/#{paths}.")
      task.pattern = pattern
      task.verbose = false
      task.ruby_opts = ["-r#{Rails.root}/lib/interrupt_test"]
    end
  end

  create_spec_task :unit, %w(unit)

end unless %w(production).include? Rails.env

