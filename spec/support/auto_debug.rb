require 'aspector'

class AutoDebug < Aspector::Base
  around do |proxy, *args, &block|
    begin
      proxy.call *args, &block
    rescue Exception => e
      puts e

      if ENV['DEBUGGER'] == 'pry'
        require 'pry'
        binding.pry
      else
        #debugger
      end
      raise
    end
  end
end

#AutoDebug.apply Capybara::Session, :methods => Capybara::Session.instance_methods(false)


