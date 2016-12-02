# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::chef_server' do
  include_context 'resources'

  let(:resource) { 'chef_server' }
  %i[
    version config opscode_user opscode_uid postgres_user postgres_uid
  ].each do |i|
    let(i) { nil }
  end
  let(:properties) do
    {
      version: version,
      config: config,
      opscode_user: opscode_user,
      opscode_uid: opscode_uid,
      postgres_user: postgres_user,
      postgres_uid: postgres_uid
    }
  end
  let(:name) { 'default' }

  shared_context 'the :create action' do
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden version property' do
    let(:version) { '1.2.3' }
  end

  shared_context 'an overridden config property' do
    let(:config) { { 'notification_email' => 'example@example.com' } }
  end

  shared_context 'an overridden opscode_user property' do
    let(:opscode_user) { 'me' }
  end

  shared_context 'an overridden opscode_uid property' do
    let(:opscode_uid) { '42' }
  end

  shared_context 'an overridden postgres_user property' do
    let(:postgres_user) { 'me' }
  end

  shared_context 'an overridden postgres_uid property' do
    let(:postgres_uid) { '42' }
  end

  shared_examples_for 'any platform' do
    context 'the :create action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'creates the opscode user' do
          expect(chef_run).to create_user(opscode_user || 'opscode')
            .with(uid: opscode_uid ? opscode_uid.to_i : 303,
                  home: '/opt/opscode/embedded',
                  system: true)
        end

        it 'creates the opscode postgres user' do
          expect(chef_run).to create_user(postgres_user || 'opscode-pgsql')
          .with(uid: postgres_uid ? postgres_uid.to_i : 304,
                home: '/var/opt/opscode/postgresql',
                system: true)
        end

        it 'creates the /data directory' do
          expect(chef_run).to create_directory('/data')
        end

        it 'symlinks the /etc/opscode directory' do
          expect(chef_run).to create_directory('/data/etc/opscode')
            .with(recursive: true)
          expect(chef_run).to create_directory('/data/etc/opscode/server.d')
            .with(recursive: true)
          expect(chef_run).to create_link('/etc/opscode')
            .with(to: '/data/etc/opscode')
        end

        it 'symlinks the /var/opt/opscode directory' do
          expect(chef_run).to create_directory('/data/var/opt/opscode')
            .with(recursive: true)
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
            .with(version: version, config: expected)
        end

        it 'builds a chef_server_config' do
          expect(chef_run).to create_chef_server_config('default')
            .with(config: config || {})
          expect(chef_run.chef_server_config('default')).to notify(
            'chef_ingredient[chef-server]'
          ).to(:reconfigure)
        end
      end

      context 'all default properties' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden version property' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden config property' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden opscode_user attribute' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden opscode_uid property' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden postgres_user property' do
        let(:postgres_user) { 'me' }

        it_behaves_like 'any property set'
      end

      context 'an overridden postgres_uid property' do
        let(:postgres_uid) { '42' }

        it_behaves_like 'any property set'
      end
    end

    context 'the :remove action' do
      include_context description

      it 'raises an error' do
        expect { chef_run }.to raise_error(NotImplementedError)
      end
    end
  end
end
