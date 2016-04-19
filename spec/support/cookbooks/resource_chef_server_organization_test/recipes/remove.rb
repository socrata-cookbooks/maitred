# Encoding: UTF-8

chef_server_organization node['org']['name'] do
  action :remove
end
