require_relative '../../../spec_helper'

describe 'resource_chef_server_config::ubuntu::14_04' do
  let(:config) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'chef_server_config',
      platform: 'ubuntu',
      version: '14.04'
    ) do |node|
      node.set['maitred']['config'] = config
    end
  end
  let(:converge) do
    runner.converge("resource_chef_server_config_test::#{action}")
  end

  context 'the default action (:create)' do
    let(:action) { :default }

    context 'a set of top-level configs' do
      let(:config) do
        {
          api_fqdn: 'example.com',
          ip_version: 'ipv6',
          notification_email: 'example@example.com'
        }
      end
      cached(:chef_run) { converge }

      it 'creates the proper default component config' do
        expect(chef_run).to create_chef_server_component_config('default')
          .with(config: {
                  'api_fqdn' => 'example.com',
                  'ip_version' => 'ipv6',
                  'notification_email' => 'example@example.com'
                })
      end
    end

    context 'a set of component configs' do
      let(:config) do
        {
          bookshelf: { 'enable' => false, 'access_key_id' => '12345' },
          erchef: { 'db_pool_size' => 30 },
          nginx: { 'ssl_protocols' => 'TLSv1.2' }
        }
      end
      cached(:chef_run) { converge }

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

    context 'a mixed set of configs' do
      let(:config) do
        {
          api_fqdn: 'example.com',
          notification_email: 'example@example.com',
          erchef: { db_pool_size: 30 },
          nginx: { ssl_protocols: 'TLSv1.2' }
        }
      end
      cached(:chef_run) { converge }

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
    let(:action) { :delete }
    cached(:chef_run) { converge }

    it 'deletes the config .d directory' do
      expect(chef_run).to delete_directory('/etc/opscode/server.d')
        .with(recursive: true)
    end

    it 'deletes the main chef-server.rb' do
      expect(chef_run).to delete_file('/etc/opscode/chef-server.rb')
    end
  end
end
