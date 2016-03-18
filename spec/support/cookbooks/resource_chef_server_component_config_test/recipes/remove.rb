# Encoding: UTF-8

chef_server_component_config node['maitred']['config'].keys[0] do
  action :remove
end
