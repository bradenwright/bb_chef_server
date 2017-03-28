#
# Cookbook Name:: bb_base
# Recipe:: _chefdk
#
# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

vault_user = chef_vault_item('bb_users','braden')

package 'git' do
  action :nothing
end.run_action(:install)

git "#{vault_user['home_path']}/chef-repo" do
  user       vault_user['username']
  repository node['app']['git']['chef-repo']['url']
  revision  node['app']['git']['chef-repo']['branch']
end

node['app']['git']['cookbooks'].each do |ckbk|
  git "#{vault_user['home_path']}/chef-repo/cookbooks/#{ckbk}" do
    user       vault_user['username']
    repository "https://github.com/bradenwright/chef-#{ckbk}.git"
    revision   'master'
  end
end

%w{ .chef .berkshelf }.each do |dir|
  directory "#{vault_user['home_path']}/#{dir}" do
    owner vault_user['username']
    group vault_user['username']
  end
end

# TODO: Maybe a better way to do this, but it works.
bash 'install chefdK' do
  code 'curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -c current -P chefdk'
  not_if { ::File.exists?("/opt/chefdk") }
end 

bash 'bundle install' do
  user vault_user['username']
  code '/opt/chefdk/embedded/bin/bundle'
  cwd "#{vault_user['home_path']}/chef-repo"
end

file "#{vault_user['home_path']}/.berkshelf/config.json" do
  owner vault_user['username']
  group vault_user['username']
  content '{"ssl": { "verify": false }}'
end

link "#{vault_user['home_path']}/.chef/knife.rb" do
  to "#{vault_user['home_path']}/chef-repo/knife.rb"
end

link "#{vault_user['home_path']}/.chef/knife.rb" do
  to "#{vault_user['home_path']}/chef-repo/knife.rb"
end

