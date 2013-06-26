# encoding: utf-8

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  #config.vm.network :forwarded_port, host: 4567, guest: 80
  config.vm.network :hostonly, "33.33.33.33"

  #config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"
  #config.ssh.forward_agent = true

  #config.vm.customize do |vm|
  #  vm.name = "Rails App Tmpl"
  #  vm.memory_size = 1024
  #end

  #config.vm.share_folder "rails_app_tmpl", "/vagrant/rails_app_tmpl", "."

  config.vm.forward_port 3000, 4567

  #config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["vendored_cookbooks", "cookbooks"]
    #chef.cookbooks_path = ["cookbooks"]

    chef.add_recipe 'application'

    chef.json.merge!({
      application: {app_name: "rails_app_tmpl"},

      rvm: {:ruby => {version: '1.9.3', implementation: 'ruby', patch_level: 'p392'}},

      postgresql: { username: "postgres", password: "postgres"},

      mysql: { server_debian_password: "root", server_root_password: "root", server_repl_password: "root"}
    })
  end

end
