name "mac_os_x"

description 'Role for Mac OS X'

run_list "role[base]", "recipe[mac_os_x]"