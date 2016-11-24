# encoding: utf-8
# frozen_string_literal: true

chef_server 'default' do
  version node['maitred']['app']['version']
  config node['maitred']['config']
  opscode_user node['maitred']['opscode_user']
  opscode_uid node['maitred']['opscode_uid']
  postgres_user node['maitred']['postgres_user']
  postgres_uid node['maitred']['postgres_uid']
end
