# -*- coding: utf-8 -*-

set :stages, %w(production staging)
set :default_stage, "staging"
set :rails_root, Dir.pwd.gsub("config","")
set :assets_path, File.join(rails_root,"public/assets")
set :mysql_conf, YAML.load_file(File.join(rails_root,"config","database.yml"))
set :file_storage, YAML.load_file(File.join(rails_root,"config","file_storage.yml"))

set :ssh_options, { forward_agent: true, keys: %w(~/.ssh/id_rsa) }

require 'capistrano/ext/multistage'