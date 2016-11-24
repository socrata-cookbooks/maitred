# encoding: utf-8
# frozen_string_literal: true

chef_server_system_user 'example' do
  uid 123
  home '/tmp/example'
end
