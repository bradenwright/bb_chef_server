name             'bb_chef_server'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures bb_chef_server'
long_description 'Installs/Configures bb_chef_server'
version          '0.1.0'
supports	 'ubuntu'

%w{
  bb_base
  chef-server
}.each do |ckbk|
  depends ckbk
end
