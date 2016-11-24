# encoding: utf-8
# frozen_string_literal: true

chef_server_component_config node['maitred']['config'].keys[0] do
  node['maitred']['config'].first[1].each do |k, v|
    send(k, v)
  end
end
