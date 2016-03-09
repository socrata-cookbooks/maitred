# Encoding: UTF-8
#
# Cookbook Name:: socrata-chef-server
# Library:: resource_chef_server
#
# Copyright 2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/resource'

class Chef
  class Resource
    # A custom resource for setting up a Chef Server.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class ChefServer < Resource
      provides :chef_server

      property :topology, String, default: 'standalone'
      property :opscode_user, String, default: 'opscode'
      property :opscode_uid, Fixnum, default: 142
      property :postgres_user, String, default: 'opscode-pgsql'
      property :postgres_uid, Fixnum, default: 143

      default_action :create

      action :create do
        user opscode_user do
          uid opscode_uid
          system true
          home '/opt/opscode/embedded'
        end
        user postgres_user do
          uid postgres_uid
          system true
          home '/opt/opscode/postgresql'
        end
        directory '/data'
        %w(/etc/opscode /var/opt/opscode).each do |d|
          directory ::File.join('/data', d) do
            owner opscode_user
            group opscode_user
            recursive true
          end
          link d do
            to ::File.join('/data', d)
          end
        end
        chef_ingredient 'chef-server' do
          config <<-EOH.gsub(/^ {12}/, '').strip
            topology '#{topology}'
          EOH
        end
        ingredient_config 'chef-server' do
          sensitive true
          notifies :reconfigure, 'chef_ingredient[chef-server]'
        end
      end

      action :remove do
        raise(NotImplementedError, ':remove action not yet implemented')
      end
    end
  end
end
