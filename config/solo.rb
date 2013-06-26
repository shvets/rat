project_root = File.dirname(File.expand_path(__FILE__))

file_cache_path "#{project_root}/../.chef/cache"
file_backup_path "#{project_root}/../.chef/backup"
cache_options( :path => "#{project_root}/../.chef/checksums", :skip_expires => true )

cookbook_path [File.join(project_root, "..", "cookbooks"),
               File.join(project_root, "..", "vendored_cookbooks")]

#json_attribs File.join(project_root, "..", "nodes", "vagrant-node.json")

roles_path File.join(project_root, "..", "roles")

