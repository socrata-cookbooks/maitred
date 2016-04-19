# Encoding: UTF-8

chef_server_organization node['org']['name'] do
  full_name node['org']['full_name'] unless node['org']['full_name'].nil?
  user node['org']['user'] unless node['org']['user'].nil?
  file node['org']['file'] unless node['org']['file'].nil?
end
