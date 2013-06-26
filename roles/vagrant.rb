name "vagrant"

description 'Role for Vagrant'

run_list "role[base]", 'recipe[application]'