require_relative '../../../spec_helper'

describe 'resource_chef_server_component_config::ubuntu::14_04' do
  let(:component) { nil }
  let(:config) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'chef_server_component_config',
      platform: 'ubuntu',
      version: '14.04'
    ) do |node|
      node.set['maitred']['config'][component] = config
    end
  end
  let(:converge) do
    runner.converge("resource_chef_server_component_config_test::#{action}")
  end

  context 'the default action (:create)' do
    let(:action) { :default }

    context 'a bookshelf component' do
      let(:component) { :bookshelf }
      let(:config) do
        {
          enable: false,
          access_key_id: '12345',
          secret_access_key: 'abc123',
          vip: 's3-test.amazonaws.com',
          external_url: 'https://s3-test.amazonaws.com'
        }
      end
      cached(:chef_run) { converge }

      it 'renders the expected config file' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          bookshelf['enable'] = false
          bookshelf['access_key_id'] = '12345'
          bookshelf['secret_access_key'] = 'abc123'
          bookshelf['vip'] = 's3-test.amazonaws.com'
          bookshelf['external_url'] = 'https://s3-test.amazonaws.com'
        EOH
        expect(chef_run).to create_file('/etc/opscode/server.d/bookshelf.rb')
          .with(content: expected)
      end
    end
  end

  context 'the :delete action' do
    let(:action) { :delete }

    context 'the bookshelf component' do
      let(:component) { :bookshelf }
      cached(:chef_run) { converge }

      it 'deletes the config file' do
        expect(chef_run).to delete_file('/etc/opscode/server.d/bookshelf.rb')
      end
    end
  end
end
