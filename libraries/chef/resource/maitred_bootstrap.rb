# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: maitred
# Library:: chef/resource/maitred_bootstrap
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
    # A custom resource for bootstrapping a new Chef Server with this cookbook.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class MaitredBootstrap < Resource
      provides :maitred_bootstrap

      default_action :run

      action :run do
        Chef::Log.warn("SERVER URL: #{Chef::Config[:chef_server_url]}")
        Chef::ServerAPI.new('https://127.0.0.1',
                            client_name: 'pivotal',
                            signing_key_filename: '/etc/opscode/pivotal.pem')
      end
    end
  end
end
