# Encoding: UTF-8
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

chef_server 'default'


chef_server_component 'bookshelf' do
  access_key_id 'a test'
  secret_access_key 'SUPERSECRET'
  vip 's3-blahblah.aws.com'
  external_url 'https://s3.amazonaws.com'
end

vs


chef_server_component_config 'bookshelf' do
  config(
    access_key_id: 'a test',
    secret_access_key: 'SUPERSECRET',
    vip: 's3-blahblah.aws.com',
    external_url: 'https://s3.amazonaws.com'
  )
end
