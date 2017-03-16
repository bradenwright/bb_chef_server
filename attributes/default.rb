#
# Cookbook Name:: bb_chef_server
# Attribute:: default
#
# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

default['chef-vault']['databag_fallback'] = true

default['bb_chef_server']['org']['id'] = 'bb'
default['bb_chef_server']['org']['name'] = 'BB'

default['chef-server']['accept_license'] = true
default['chef-server']['addons'] = %w{ manage reporting }
default['app']['domain_name'] = "#{node.chef_environment}.bb.com"
default['ssl']['ca_fqdn'] = "ca.#{node['app']['domain_name']}"
default['chef-server']['api_fqdn'] = "chef-server.#{node['app']['domain_name']}"

default['ssl']['common_name'] = node['chef-server']['api_fqdn']

default['chef-server']['configuration'] = <<-EOS
notification_email 'braden.wright.it@gmail.com'
EOS

# ChefDK
default['app']['git']['chef-repo']['url'] = 'https://github.com/bradenwright/chef-repo.git'
default['app']['git']['chef-repo']['branch'] = 'master'
default['app']['git']['cookbooks'] = %w{ bb_base bb_chef_server }

