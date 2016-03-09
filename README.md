Socrata Chef Server Cookbook
============================
[![Cookbook Version](https://img.shields.io/cookbook/v/socrata-chef-server.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/socrata-chef-server-chef.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-cookbooks/socrata-chef-server-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-cookbooks/socrata-chef-server-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/socrata-chef-server
[travis]: https://travis-ci.org/socrata-cookbooks/socrata-chef-server-chef
[codeclimate]: https://codeclimate.com/github/socrata-cookbooks/socrata-chef-server-chef
[coveralls]: https://coveralls.io/r/socrata-cookbooks/socrata-chef-server-chef

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

Configures a basic, standalone Chef server.

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
