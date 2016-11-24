# encoding: utf-8
# frozen_string_literal: true

chef_server_config 'default' do
  config node['maitred']['config']
end
