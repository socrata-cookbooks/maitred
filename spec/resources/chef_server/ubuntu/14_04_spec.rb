require_relative '../../../spec_helper'

describe 'resource_chef_server::ubuntu::14_04' do
  %w(
    version config opscode_user opscode_uid postgres_user postgres_uid
  ).each do |i|
    let(i) { nil }
  end
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'chef_server', platform: 'ubuntu', version: '14.04'
    ) do |node| 
      node.set['maitred']['app']['version'] = version unless version.nil?
      %i(config opscode_user opscode_uid postgres_user postgres_uid).each do |i|
        node.set['maitred'][i] = send(i) unless send(i).nil?
      end
    end
  end
  let(:converge) { runner.converge("resource_chef_server_test::#{action}") }

  context 'the default action (:create)' do
    let(:action) { :default }

    shared_examples_for 'any attributes' do
      it 'creates the opscode user' do
        expect(chef_run).to create_user(opscode_user || 'opscode')
          .with(uid: opscode_uid ? opscode_uid.to_i : 142,
                system: true,
                home: '/opt/opscode/embedded')
      end

      it 'creates the opscode postgres user' do
        expect(chef_run).to create_user(postgres_user || 'opscode-pgsql')
          .with(uid: postgres_uid ? postgres_uid.to_i : 143,
                system: true,
                home: '/opt/opscode/postgresql')
      end

      it 'creates the /data directory' do
        expect(chef_run).to create_directory('/data')
      end

      it 'symlinks the /etc/opscode directory' do
        expect(chef_run).to create_directory('/data/etc/opscode')
          .with(owner: opscode_user || 'opscode',
                group: opscode_user || 'opscode',
                recursive: true)
        expect(chef_run).to create_directory('/data/etc/opscode/server.d')
          .with(owner: opscode_user || 'opscode',
                group: opscode_user || 'opscode',
                recursive: true)
        expect(chef_run).to create_link('/etc/opscode')
          .with(to: '/data/etc/opscode')
      end

      it 'symlinks the /var/opt/opscode directory' do
        expect(chef_run).to create_directory('/data/var/opt/opscode')
          .with(owner: opscode_user || 'opscode',
                group: opscode_user || 'opscode',
                recursive: true)
        expect(chef_run).to create_link('/var/opt/opscode')
          .with(to: '/data/var/opt/opscode')
      end

      it 'installs the chef-server ingredient' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          Dir.glob(
            File.join('/etc/opscode', "server.d", "*.rb")
          ).each do |conf|
            self.instance_eval(IO.read(conf), conf, 1)
          end
        EOH
        expect(chef_run).to install_chef_ingredient('chef-server')
          .with(version: version || :latest, config: expected)
      end

      it 'builds a chef_server_config' do
        expect(chef_run).to create_chef_server_config('default')
          .with(config: config || {})
        expect(chef_run.chef_server_config('default')).to notify(
          'chef_ingredient[chef-server]'
        ).to(:reconfigure)
      end
    end

    context 'default attributes' do
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'
    end

    context 'an overridden version attribute' do
      let(:version) { '1.2.3' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'
    end

    context 'an overridden config attribute' do
      let(:config) { { 'notification_email' => 'example@example.com' } }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'
    end

    context 'an overridden opscode_user attribute' do
      let(:opscode_user) { 'me' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'
    end

    context 'an overridden opscode_uid attribute' do
      let(:opscode_uid) { '42' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'
    end

    context 'an overridden postgres_user attribute' do
      let(:postgres_user) { 'me' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'
    end

    context 'an overridden postgres_uid attribute' do
      let(:postgres_uid) { '42' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'
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
