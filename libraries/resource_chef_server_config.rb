# Encoding: UTF-8
#
# Cookbook Name:: maitred
# Library:: resource_chef_server_config
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
    # A custom resource for the entirety of a Chef Server configuration, which
    # may include multiple "component" resources (Bookshelf, Nginx, etc.)
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class ChefServerConfig < Resource
      provides :chef_server_config

      property :config, Hash, default: {}

      #
      # Allow manipulation of the config hash by calling unrecognized methods.
      #
      def method_missing(method_symbol, *args, &block)
        super
      rescue NoMethodError
        if !block.nil? || args.length != 1
          super
        else
          config[method_symbol] = args[0]
        end
      end

      default_action :create

      #
      # Generate the configs for this Chef Server.
      #
      action :create do
        base = new_resource.config.select { |_, v| !v.is_a?(Hash) }
        rest = new_resource.config.select { |_, v| v.is_a?(Hash) }

        chef_server_component_config 'default' do
          config base
        end

        rest.each do |k, v|
          chef_server_component_config k do
            config v
          end
        end
      end

      #
      # Delete the configs for this Chef Server.
      #
      action :delete do
        directory '/etc/opscode/server.d' do
          recursive true
          action :delete
        end
        file '/etc/opscode/chef-server.rb' do
          action :delete
        end
      end
    end
  end
end
