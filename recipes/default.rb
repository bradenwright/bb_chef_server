#
# Cookbook Name:: bb_chef_server
# Recipe:: default

# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'bb_base'
include_recipe 'chef-server'
include_recipe 'chef-server::addons'
#TODO: setup ssl
#TODO: setup users
#TODO: upload cookbooks, data bags, etc
