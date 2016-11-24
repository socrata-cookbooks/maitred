# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: maitred
# Library:: resource_chef_server_organization
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
    # A custom resource for managing Chef Server organizations that operates
    # by shelling out to chef-server-ctl.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class ChefServerOrganization < Resource
      provides :chef_server_organization

      property :full_name, String, default: ''
      property :user, [String, nil], default: nil
      property :file, [String, nil], default: nil

      default_action :create

      action :create do
        execute "Create Chef Server organization: '#{new_resource.name}'" do
          cmd = "chef-server-ctl org-create #{new_resource.name} " \
                "'#{new_resource.full_name}'"
          cmd << " -a #{new_resource.user}" if new_resource.user
          cmd << " -f #{new_resource.file}" if new_resource.file
          command cmd
          not_if "chef-server-ctl org-show #{new_resource.name}"
        end
      end

      action :remove do
        execute "Delete Chef Server organization: '#{new_resource.name}'" do
          command "chef-server-ctl org-delete #{new_resource.name}"
          only_if "chef-server-ctl org-show #{new_resource.name}"
        end
      end
    end
  end
end
