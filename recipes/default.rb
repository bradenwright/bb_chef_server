#
# Cookbook Name:: bb_chef_server
# Recipe:: default

# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

org_id = node['bb_chef_server']['org']['id']
org_name = node['bb_chef_server']['org']['name']

db_users = {
  "username": "bwright",
  "first_name": "Braden",
  "last_name": "Wright",
  "email": "braden.wright.it@gmail.com",
  "password": "p@ssw0rd"
}

include_recipe 'bb_base'
include_recipe 'chef-server'
include_recipe 'chef-server::addons'
#TODO: setup ssl
#TODO: setup users

bash 'chef_server_setup_user_bwright' do
  code "chef-server-ctl user-create #{db_users['username']} #{db_users['first_name']} #{db_users['last_name']}  #{db_users['email']} #{db_users['password']} -f /tmp/#{db_users['username']}.key"
  not_if { ::File.exist? '/tmp/bwright.key' }
end

bash "chef_server_setup_org_#{org_id}" do
  code "chef-server-ctl org-create #{org_id} #{org_name} -a bwright -f /etc/chef/#{org_name}-validator.pem"
  not_if { ::File.exist? "/etc/chef/#{org_name}-validator.pem" }
end

#TODO: upload cookbooks, data bags, etc
