require_relative '../../../spec_helper'

describe 'resource_chef_server::ubuntu::14_04' do
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(step_into: 'chef_server',
                             platform: 'ubuntu',
                             version: '14.04')
  end
  let(:converge) { runner.converge("resource_chef_server_test::#{action}") }

  context 'the default action (:create)' do
    let(:action) { :default }
    cached(:chef_run) { converge }

    it 'creates the opscode user' do
      expect(chef_run).to create_user('opscode')
        .with(uid: 142, system: true, home: '/opt/opscode/embedded')
    end

    it 'creates the opscode postgres user' do
      expect(chef_run).to create_user('opscode-pgsql')
        .with(uid: 143, system: true, home: '/opt/opscode/postgresql')
    end

    it 'creates the /data directory' do
      expect(chef_run).to create_directory('/data')
    end

    it 'symlinks the /etc/opscode directory' do
      expect(chef_run).to create_directory('/data/etc/opscode')
        .with(owner: 'opscode', group: 'opscode', recursive: true)
      expect(chef_run).to create_link('/etc/opscode')
        .with(to: '/data/etc/opscode')
    end

    it 'symlinks the /var/opt/opscode directory' do
      expect(chef_run).to create_directory('/data/var/opt/opscode')
        .with(owner: 'opscode', group: 'opscode', recursive: true)
      expect(chef_run).to create_link('/var/opt/opscode')
        .with(to: '/data/var/opt/opscode')
    end

    it 'installs the chef-server ingredient' do
      expect(chef_run).to install_chef_ingredient('chef-server')
        .with(config: "topology 'standalone'")
    end

    it 'configures the chef-server ingredient' do
      expect(chef_run).to render_ingredient_config('chef-server')
        .with(sensitive: true)
      expect(chef_run.ingredient_config('chef-server'))
        .to notify('chef_ingredient[chef-server]').to(:reconfigure)
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'raises an error' do
      expect { chef_run }.to raise_error(NotImplementedError)
    end
  end
end
