Maitred Cookbook
================
[![Cookbook Version](https://img.shields.io/cookbook/v/maitred.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/maitred.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-cookbooks/maitred.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-cookbooks/maitred.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/maitred
[travis]: https://travis-ci.org/socrata-cookbooks/maitred
[codeclimate]: https://codeclimate.com/github/socrata-cookbooks/maitred
[coveralls]: https://coveralls.io/r/socrata-cookbooks/maitred

A Chef cookbook for configuring a new Chef server.

Requirements
============

This cookbook uses the
[chef-ingredient](https://supermarket.chef.io/cookbooks/chef-ingredient)
cookbook to install Chef Server components.

Usage
=====

Either add the included recipe to your run list or utilize the custom resources
to create a recipe of your own.

Recipes
=======

***default***

Performs an attribute-driven installation and configuration of a Chef Server.

Attributes
==========

***default***

    default['maitred']['app']['version'] = nil

If desired, a specific version of Chef Server can be installed.

    default['maitred']['config'] = {}

Any attributes passed in as part of the config hash will be rendered to
Chef Server's config files.

Resources
=========

***chef_server***

A resource wrapper for configuring a new Chef server.

Syntax:

    chef_server 'default' do
        topology 'standalone'
        action :create
    end

Actions:

| Action    | Description                       |
|-----------|-----------------------------------|
| `:create` | Install and configure Chef Server |

Attributes:

| Attribute  | Default        | Description              |
|------------|----------------|--------------------------|
| topology   | `'standalone'` | The Chef Server topology |
| action     | `:create`      | Action(s) to perform     |

***chef_server_config***

A resource encompassing a collection of `chef_server_component_config`
resources representing the various Chef Server "components" (Erchef, Nginx,
Bookshelf, etc.).

Syntax:

    chef_server_config 'default' do
      topology ha
      bookshelf { enable: false }
      postgresql { external: true, vip: 'example.com' }
      action :create
    end

Actions:

| Action    | Description                                      |
|-----------|--------------------------------------------------|
| `:create` | Render config files for all properties passed in |
| `:delete` | Delete the config files                          |

Attributes:

| Attribute  | Default   | Description                                |
|------------|-----------|--------------------------------------------|
| config     | `{}`      | Configs can be passed in as a full hash... |
| _wildcard_ | N/A       | ...or as individual properties             |
| action     | `:create` | Action(s) to perform                       |

***chef_server_component_config***

A resource to allow individual configuration of each Chef Server component:

| Component  | Notes                                     |
|------------|-------------------------------------------|
| default    | Top-level settings, e.g. 'topology', etc. |
| ha         | Chef Server's High Availability settings  |
| erchef     |                                           |
| nginx      |                                           |
| bookshelf  |                                           |
| postgresql |                                           |
| ldap       |                                           |
| rabbitmq   |                                           |
| account    |                                           |
| expander   |                                           |
| solr       |                                           |

Any properties passed in will be rendered in the final template. It's up the
user and Chef Server itself to validate the configuration. See Chef, Inc.'s
documentation [here](https://docs.chef.io/config_rb_server.html) and
[here](https://docs.chef.io/config_rb_server_optional_settings.html) for
further details

Syntax:

    chef_server_component_config 'bookshelf' do
      access_key_id '12345'
      secret_access_key 'abc123'
      vip 's3-test.amazonaws.com'
      external_url 'https://s3-test.amazonaws.com
      action :create
    end

Actions:

| Action    | Description                                                |
|-----------|------------------------------------------------------------|
| `:create` | Render the config file for the given Chef Server component |
| `:delete` | Delete the config file                                     |

Attributes:

| Attribute  | Default   | Description                                         |
|------------|-----------|-----------------------------------------------------|
| config     | `{}`      | Component config can be passed in as a full hash... |
| _wildcard_ | N/A       | ...or as individual properties                      |
| action     | `:create` | Action(s) to perform                                |

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <jonathan.hartman@socrata.com>

Copyright 2016, Socrata, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
