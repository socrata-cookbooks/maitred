require_relative '../../../spec_helper'

describe 'resource_chef_server_organization::ubuntu::14_04' do
  let(:name) { 'myorg' }
  %w(full_name user file).each do |i|
    let(i) { nil }
  end
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'chef_server_organization',
      platform: 'ubuntu',
      version: '14.04'
    ) do |node|
      node.set['org']['name'] = name
      %i(full_name user file).each do |a|
        node.set['org'][a] = send(a) unless send(a).nil?
      end
    end
  end
  let(:converge) do
    runner.converge("resource_chef_server_organization_test::#{action}")
  end

  context 'the default action (:create)' do
    let(:action) { :default }

    before(:each) do
      stub_command('chef-server-ctl org-show myorg').and_return(false)
      stub_command('chef-server-ctl org-show otherorg').and_return(true)
    end

    shared_examples_for 'any attributes' do
      it 'creates the organization' do
        expect(chef_run).to create_chef_server_organization(name).with(
          full_name: full_name || '',
          user: user,
          file: file
        )
      end
    end

    context 'default attributes' do
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'

      it 'executes the correct org-create command' do
        expect(chef_run).to run_execute(
          "Create Chef Server organization: 'myorg'"
        ).with(command: "chef-server-ctl org-create myorg ''")
      end
    end

    context 'an overridden full_name attribute' do
      let(:full_name) { 'mememe' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'

      it 'executes the correct org-create command' do
        expect(chef_run).to run_execute(
          "Create Chef Server organization: 'myorg'"
        ).with(command: "chef-server-ctl org-create myorg 'mememe'")
      end
    end

    context 'an overridden user attribute' do
      let(:user) { 'dave' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'

      it 'executes the correct org-create command' do
        expect(chef_run).to run_execute(
          "Create Chef Server organization: 'myorg'"
        ).with(command: "chef-server-ctl org-create myorg '' -a dave")
      end
    end

    context 'an overridden file attribute' do
      let(:file) { '/tmp/thatone' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'

      it 'executes the correct org-create command' do
        expect(chef_run).to run_execute(
          "Create Chef Server organization: 'myorg'"
        ).with(command: "chef-server-ctl org-create myorg '' -f /tmp/thatone")
      end
    end

    context 'an organization that already exists' do
      let(:name) { 'otherorg' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'

      it 'does not execute an org-create' do
        expect(chef_run).to_not run_execute(
          "Create Chef Server organization: 'otherorg'"
        )
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }

    before(:each) do
      stub_command('chef-server-ctl org-show myorg').and_return(true)
      stub_command('chef-server-ctl org-show otherorg').and_return(false)
    end

    shared_examples_for 'any context' do
      it 'removes the organization' do
        expect(chef_run).to remove_chef_server_organization(name)
      end
    end

    context 'an existing organization' do
      cached(:chef_run) { converge }

      it 'executes the correct org-create command' do
        expect(chef_run).to run_execute(
          "Delete Chef Server organization: 'myorg'"
        ).with(command: 'chef-server-ctl org-delete myorg')
      end
    end

    context 'a nonexistent user' do
      let(:name) { 'otherorg' }
      cached(:chef_run) { converge }

      it 'does not execute an org-create command' do
        expect(chef_run).to_not run_execute(
          "Delete Chef Server organization: 'otherorg'"
        )
      end
    end
  end
end
