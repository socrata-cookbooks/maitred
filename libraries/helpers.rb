# Encoding: UTF-8
#
# Cookbook Name:: maitred
# Library:: helpers
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

module Maitred
  # A set of helper methods for Chef Server configuration.
  #
  # @author Jonathan Hartman <jonathan.hartman@socrata.com>
  class Helpers
    #
    # Offer some nicknames for a few of the Chef Server components. For every
    # other component, its full name in chef-server.rb will be its property
    # name in this cookbook.
    #
    COMPONENT_MAP ||= {
      erchef: 'opscode_erchef',
      account: 'opscode_account',
      expander: 'opscode_expander',
      solr: 'opscode_solr4'
    }.freeze

    class << self
      #
      # Construct a section of config suitable for a chef-server.rb from a
      # Chef Server component name and config hash for it. Components include
      # such things as:
      #
      #   * ha
      #   * nginx
      #   * bookshelf
      #
      # E.g. turn this :default (base) config hash:
      #
      #   {
      #     topology: 'ha',
      #     ip_version: 'ipv4'
      #   }
      #
      # ...into this string that can be written to chef-server.rb
      #
      #   topology 'ha'
      #   ip_version 'ipv4'
      #
      # Or this :ha config hash:
      #
      #   {
      #     provider: 'aws',
      #     aws_access_key_id: 'SOMESTUFF',
      #     aws_secret_access_key: 'ITSASECRET',
      #     ebs_volume_id: 'vol-abcdefg',
      #     ebs_device: '/dev/xvdf'
      #   }
      #
      # ...into this string:
      #
      #   ha['provider'] = 'aws'
      #   ha['aws_access_key_id'] = 'SOMESTUFF'
      #   ha['aws_secret_access_key'] = 'ITSASECRET'
      #   ha['ebs_volume_id'] = 'vol-abcdefg'
      #   ha['ebs_device'] = '/dev/xvdf'
      #
      # We also recognize shortcut names for a few components. For example,
      # "erchef" can be passed in as a component name and will be translated
      # into "opscode_erchef" as required for the config file.
      #
      # For top-level settings that aren't hashes in chef-server.rb (e.g.
      # "bootstrap", "api_fqdn", etc.), the component name "default" should be
      # used.
      #
      # @param component [Symbol] the name of this config component,
      #                                 e.g. :ldap, :nginx, etc.
      #
      # @return [String] a multi-line string representation of that config
      #                  ready to write to a chef-server.rb or an empty string.
      #
      def component_config_for(component, config = {})
        (config || {}).map do |k, v|
          if component.to_sym == :default
            "#{k} #{quote(v)}"
          elsif COMPONENT_MAP[component.to_sym]
            "#{COMPONENT_MAP[component.to_sym]}['#{k}'] = #{quote(v)}"
          else
            "#{component}['#{k}'] = #{quote(v)}"
          end
        end.join("\n")
      end

      #
      # Prepare an item to be written to a Chef Server config by putting quotes
      # around it if it's a string, or not if it's a boolean value.
      #
      # @param item [TrueClass,FalseClass,String] an item to make write-ready
      #
      # @return [String] that item represented as a quoted or unquoted String
      #
      def quote(item)
        if [TrueClass, FalseClass, Fixnum].include?(item.class)
          item.to_s
        else
          %('#{item.gsub("'", "\\\\'")}')
        end
      end
    end
  end
end
