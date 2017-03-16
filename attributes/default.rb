#
# Cookbook Name:: bb_chef_server
# Attribute:: default
#
# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

default['chef-server']['accept_license'] = true
default['chef-server']['addons'] = %w{ manage reporting }

default['chef-server']['configuration'] = <<-EOS
notification_email 'braden.wright.it@gmail.com'
EOS

