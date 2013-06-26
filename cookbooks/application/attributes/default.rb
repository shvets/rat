set_unless[:application][:user] = "vagrant"
set_unless[:application][:root] = "/vagrant/" + node[:application][:app_name]

set_unless[:application][:home] = "/home/#{node[:application][:user]}"
set_unless[:application][:bash_env] = { 'HOME' => node[:application][:home], 'USER' => node[:application][:user] }



