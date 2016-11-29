# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::chef_server_config' do
  include_context 'resources'

  let(:resource) { 'chef_server_config' }
  %i[config].each { |i| let(i) { nil } }
  let(:properties) { { config: config } }
  let(:name) { 'default' }

  shared_context 'the :create action' do
  end

  shared_context 'the :delete action' do
    let(:action) { :delete }
  end

  shared_context 'properties for a set of top-level configs' do
    let(:config) do
      {
        api_fqdn: 'example.com',
        ip_version: 'ipv6',
        notification_email: 'example@example.com'
      }
    end
  end

  shared_context 'properties for a set of component configs' do
    let(:config) do
      {
        bookshelf: { 'enable' => false, 'access_key_id' => '12345' },
        erchef: { 'db_pool_size' => 30 },
        nginx: { 'ssl_protocols' => 'TLSv1.2' }
      }
    end
  end

  shared_context 'properties for a mixed set of configs' do
    let(:config) do
      {
        api_fqdn: 'example.com',
        notification_email: 'example@example.com',
        erchef: { db_pool_size: 30 },
        nginx: { ssl_protocols: 'TLSv1.2' }
      }
    end
  end

  shared_examples_for 'any platform' do
    context 'the :create action' do
      include_context description

      context 'properties for a set of top-level configs' do
        include_context description

        it 'creates the proper default component config' do
          expect(chef_run).to create_chef_server_component_config('default')
            .with(config: {
                    'api_fqdn' => 'example.com',
                    'ip_version' => 'ipv6',
                    'notification_email' => 'example@example.com'
                  })
        end
      end

      context 'properties for a set of component configs' do
        include_context description

        it 'creates the proper bookshelf component config' do
          expect(chef_run).to create_chef_server_component_config('bookshelf')
            .with(config: { 'enable' => false, 'access_key_id' => '12345' })
        end

        it 'creates the proper erchef component config' do
          expect(chef_run).to create_chef_server_component_config('erchef')
            .with(config: { 'db_pool_size' => 30 })
        end

        it 'creates the proper nginx component config' do
          expect(chef_run).to create_chef_server_component_config('nginx')
            .with(config: { 'ssl_protocols' => 'TLSv1.2' })
        end
      end

      context 'properties for a mixed set of configs' do
        include_context description

        it 'creates the proper default component config' do
          expect(chef_run).to create_chef_server_component_config('default')
            .with(config: {
                    'api_fqdn' => 'example.com',
                    'notification_email' => 'example@example.com'
                  })
        end

        it 'creates the proper erchef component config' do
          expect(chef_run).to create_chef_server_component_config('erchef')
            .with(config: { 'db_pool_size' => 30 })
        end

        it 'creates the proper nginx component config' do
          expect(chef_run).to create_chef_server_component_config('nginx')
            .with(config: { 'ssl_protocols' => 'TLSv1.2' })
        end
      end
    end

    context 'the :delete action' do
      include_context description

      it 'deletes the config .d directory' do
        expect(chef_run).to delete_directory('/etc/opscode/server.d')
          .with(recursive: true)
      end

      it 'deletes the main chef-server.rb' do
        expect(chef_run).to delete_file('/etc/opscode/chef-server.rb')
      end
    end
  end
end
