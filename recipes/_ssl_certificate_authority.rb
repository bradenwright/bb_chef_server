#
# Cookbook Name:: bb_chef_server
# Recipe:: _ssl_certificate_authority

# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

ca_cert = ssl_certificate node['ssl']['ca_fqdn'] do
  common_name node['ssl']['ca_fqdn']
  source 'data-bag'#'chef-vault'
  bag 'ssl'
  item 'ca_cert'
  key_item_key 'key_content'
  cert_item_key 'cert_content'
end

cert = ssl_certificate node['app']['domain_name'] do
  cert_source 'with_ca'
  ca_cert_path ca_cert.cert_path
  ca_key_path ca_cert.key_path
end

=begin
cert = ssl_certificate node['chef-server']['api_fqdn'] do
  namespace node['ssl']
  key_source 'self-signed'
  cert_source 'self-signed'
end
=end

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

