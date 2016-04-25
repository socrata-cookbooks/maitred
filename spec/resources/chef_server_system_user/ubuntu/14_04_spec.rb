require_relative '../../../spec_helper'

describe 'resource_chef_server_system_user::ubuntu::14_04' do
  let(:runner) do
    ChefSpec::SoloRunner.new(step_into: 'chef_server_system_user',
                             platform: 'ubuntu',
                             version: '14.04')
  end
  let(:converge) do
    runner.converge("resource_chef_server_system_user_test::#{action}")
  end

  context 'the default action (:create)' do
    let(:action) { :default }
    cached(:chef_run) { converge }

    it 'creates the user' do
      expect(chef_run).to create_user('example')
        .with(uid: 123, system: true, home: '/tmp/example')
    end

    it 'uploads the user to a data bag' do
      expect(chef_run).to run_ruby_block('Upload user to data bag')
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the user' do
      expect(chef_run).to remove_user('example')
    end
  end
end
