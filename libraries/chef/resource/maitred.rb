# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: maitred
# Library:: chef/resource/maitred
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
require_relative 'maitred_config'
require_relative 'maitred_bootstrap'

class Chef
  class Resource
    # A custom resource for setting up a Chef Server.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class Maitred < Resource
      provides :maitred

      property :version, String
      property :config_dir, String, default: '/etc/opscode/server.d'
      property :config, Hash, default: {}
      property :opscode_user, String, default: 'opscode'
      property :opscode_uid, Integer, coerce: proc { |v| v.to_i }, default: 303
      property :postgres_user, String, default: 'opscode-pgsql'
      property :postgres_uid, Integer, coerce: proc { |v| v.to_i }, default: 304

      default_action :create

      action :create do
        user new_resource.opscode_user do
          uid new_resource.opscode_uid
          home '/opt/opscode/embedded'
          system true
        end

        user new_resource.postgres_user do
          uid new_resource.postgres_uid
          home '/var/opt/opscode/postgresql'
          system true
        end

        directory '/data'
        %w[/etc/opscode /var/opt/opscode].each do |d|
          directory ::File.join('/data', d) do
            recursive true
          end

          link d do
            to ::File.join('/data', d)
          end
        end
        chef_ingredient 'chef-server' do
          version new_resource.version unless new_resource.version.nil?
          config <<-EOH.gsub(/^ {12}/, '').strip
            Dir.glob('#{new_resource.config_dir}/*.rb').each do |conf|
              self.instance_eval(IO.read(conf), conf, 1)
            end
          EOH
        end
        maitred_config new_resource.config_dir do
          config new_resource.config
          notifies :reconfigure, 'chef_ingredient[chef-server]'
        end
      end

      action :remove do
        raise(NotImplementedError, ':remove action not yet implemented')
      end
    end
  end
end
