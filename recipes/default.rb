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

#include_recipe 'bb_chef_server::_ssl_certificate_authority'

cert = ssl_certificate node['chef-server']['api_fqdn'] do
  namespace node['ssl']
  key_source 'self-signed'
  cert_source 'self-signed'
end

chef_server_crt = "/var/opt/opscode/nginx/ca/#{node['ssl']['common_name']}.crt"
chef_server_key = "/var/opt/opscode/nginx/ca/#{node['ssl']['common_name']}.key"

file chef_server_crt do
  action :delete
  not_if { ::File.symlink? chef_server_crt }
end

link chef_server_crt do
  to cert.chain_combined_path
end

file chef_server_key do
  action :delete
  not_if { ::File.symlink? chef_server_key }
end

link chef_server_key do
  to cert.key_path
end

bash "chef_server_setup_user_#{vault_users['username']}" do
  code "chef-server-ctl user-create #{vault_users['username']} #{vault_users['first_name']} #{vault_users['last_name']}  #{vault_users['email']} #{vault_users['password']} -f #{vault_users['home_path']}/.chef/#{vault_users['username']}.pem"
  not_if { ::File.exist? "#{vault_users['home_path']}/.chef/#{vault_users['username']}.pem" }
end
#TODO: if .key exists upload it to a data bag??? or don't save file at all???

bash "chown_chef_#{vault_users['username']}_pem" do
  code "chown #{vault_users['username']}:#{vault_users['username']} #{vault_users['home_path']}/.chef/#{vault_users['username']}.pem"
end

bash "chef_server_setup_org_#{org_id}" do
  code "chef-server-ctl org-create #{org_id} #{org_name} -a #{vault_users['username']} -f /etc/chef/#{org_id}-validator.pem"
  not_if { ::File.exist? "/etc/chef/#{org_id}-validator.pem" }
end

# Download cookbooks via git
# Upload cookbooks via knife?

#TODO: upload cookbooks, data bags, etc
include_recipe 'bb_chef_server::_chefdk'
