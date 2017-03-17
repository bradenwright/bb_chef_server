#
# Cookbook Name:: bb_chef_server
# Recipe:: default

# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'bb_base'

org_id = node['bb_chef_server']['org']['id']
org_name = node['bb_chef_server']['org']['name']
vault_users = chef_vault_item('bb_users','braden')

include_recipe 'chef-server'
include_recipe 'chef-server::addons'
#TODO: setup ssl
#TODO: setup users

bash "chef_server_setup_user_#{vault_users['username']}" do
  code "chef-server-ctl user-create #{vault_users['username']} #{vault_users['first_name']} #{vault_users['last_name']}  #{vault_users['email']} #{vault_users['password']} -f /tmp/#{vault_users['username']}.key"
  not_if { ::File.exist? "/tmp/#{vault_users['username']}.key" }
end

#TODO: if /tmp/.key exists upload it to a data bag??? or don't save file at all???

bash "chef_server_setup_org_#{org_id}" do
  code "chef-server-ctl org-create #{org_id} #{org_name} -a #{vault_users['username']} -f /etc/chef/#{org_id}-validator.pem"
  not_if { ::File.exist? "/etc/chef/#{org_id}-validator.pem" }
end

# Download cookbooks via git
# Upload cookbooks via knife?

#TODO: upload cookbooks, data bags, etc

