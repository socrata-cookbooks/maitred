# encoding: utf-8
# frozen_string_literal: true

chef_server_organization node['org']['name'] do
  action :remove
end
