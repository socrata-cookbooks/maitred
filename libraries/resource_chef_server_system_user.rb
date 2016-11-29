# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: maitred
# Library:: resource_chef_server_system_user
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
    # A custom resource for setting up Chef Server system users and storing
    # their information in data bags.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class ChefServerSystemUser < Resource
      provides :chef_server_system_user

      property :uid, Integer, coerce: proc { |v| v.to_i }, required: true
      property :home, String, required: true

      default_action :create

      action :create do
        user new_resource.name do
          uid new_resource.uid
          system true
          home new_resource.home
        end
        ruby_block 'Upload user to data bag' do
          block do
            unless Chef::DataBag.list.keys.include?('users')
              users = Chef::DataBag.new
              users.name('users')
              users.create
            end

            new_user = Chef::DataBagItem.new
            new_user.data_bag('users')
            new_user.raw_data = {
              'id' => new_resource.name,
              'uid' => new_resource.uid,
              'gid' => new_resource.uid,
              'home' => new_resource.home,
              'shell' => '/usr/sbin/nologin'
            }
            new_user.save
          end
        end
      end

      action :remove do
        user new_resource.name do
          action :remove
        end
      end
    end
  end
end
