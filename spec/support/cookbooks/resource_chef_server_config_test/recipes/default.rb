# Encoding: UTF-8

chef_server_config 'default' do
  config node['maitred']['config']
end
