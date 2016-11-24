# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: maitred
# Recipe:: default
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

version = node['maitred']['app']['version']
opscode_user = node['maitred']['app']['opscode_user']
opscode_uid = node['maitred']['app']['opscode_uid']
postgres_user = node['maitred']['app']['postgres_user']
postgres_uid = node['maitred']['app']['postgres_uid']

chef_server 'default' do
  version version unless version.nil?
  opscode_user opscode_user unless opscode_user.nil?
  opscode_uid opscode_uid unless opscode_uid.nil?
  postgres_user postgres_user unless postgres_user.nil?
  postgres_uid postgres_uid unless postgres_uid.nil?
  config node['maitred']['config']
end
