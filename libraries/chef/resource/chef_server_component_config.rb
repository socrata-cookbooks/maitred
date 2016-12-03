# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: maitred
# Library:: chef/resource/chef_server_component_config
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
require_relative '../../helpers'

class Chef
  class Resource
    # A custom resource for the configuration block of a specific Chef Server
    # component (e.g. bookshelf, postgresql, etc.).
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class ChefServerComponentConfig < Resource
      RECOGNIZED_COMPONENTS = Maitred::Helpers::COMPONENT_MAP.keys

      provides :chef_server_component_config

      property :component, String, name_property: true, coerce: proc { |v| v.to_s }
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
      # Generate the config file for this Chef Server component.
      #
      action :create do
        file path do
          content Maitred::Helpers.component_config_for(new_resource.component,
                                                        new_resource.config)
        end
      end

      #
      # Delete the config file for this Chef Server component.
      #
      action :delete do
        file(path) { action :delete }
      end

      #
      # Construct the full path of the config file for this component.
      #
      # @return [String] a path to the config file
      #
      def path
        ::File.join('/etc/opscode/server.d', "#{component}.rb")
      end
    end
  end
end
