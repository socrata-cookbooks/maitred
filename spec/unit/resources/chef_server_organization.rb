# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::chef_server_organization' do
  include_context 'resources'

  let(:resource) { 'chef_server_organization' }
  %i(full_name user file).each { |i| let(i) { nil } }
  let(:properties) { { full_name: full_name, user: user, file: file } }
  let(:name) { 'myorg' }

  before(:each) do
    stub_command('chef-server-ctl org-show myorg').and_return(false)
    stub_command('chef-server-ctl org-show otherorg').and_return(true)
  end

  shared_context 'the :create action' do
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden full_name property' do
    let(:full_name) { 'mememe' }
  end

  shared_context 'an overridden user property' do
    let(:user) { 'dave' }
  end

  shared_context 'an overridden file property' do
    let(:file) { '/tmp/thatone' }
  end

  shared_context 'an organization that already exists' do
    let(:name) { 'otherorg' }
  end

  shared_examples_for 'any platform' do
    context 'the :create action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'creates the organization' do
          expect(chef_run).to create_chef_server_organization(name).with(
            full_name: full_name || '',
            user: user,
            file: file
          )
        end
      end

      context 'all default properties' do
        include_context description

        it_behaves_like 'any property set'

        it 'executes the correct org-create command' do
          expect(chef_run).to run_execute(
            "Create Chef Server organization: 'myorg'"
          ).with(command: "chef-server-ctl org-create myorg ''")
        end
      end

      context 'an overridden full_name property' do
        include_context description

        it_behaves_like 'any property set'

        it 'executes the correct org-create command' do
          expect(chef_run).to run_execute(
            "Create Chef Server organization: 'myorg'"
          ).with(command: "chef-server-ctl org-create myorg 'mememe'")
        end
      end

      context 'an overridden user property' do
        include_context description

        it_behaves_like 'any property set'

        it 'executes the correct org-create command' do
          expect(chef_run).to run_execute(
            "Create Chef Server organization: 'myorg'"
          ).with(command: "chef-server-ctl org-create myorg '' -a dave")
        end
      end

      context 'an overridden file property' do
        include_context description

        it_behaves_like 'any property set'

        it 'executes the correct org-create command' do
          expect(chef_run).to run_execute(
            "Create Chef Server organization: 'myorg'"
          ).with(command: "chef-server-ctl org-create myorg '' -f /tmp/thatone")
        end
      end

      context 'an organization that already exists' do
        include_context description

        it_behaves_like 'any property set'

        it 'does not execute an org-create' do
          expect(chef_run).to_not run_execute(
            "Create Chef Server organization: 'otherorg'"
          )
        end
      end
    end

    context 'the :remove action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'removes the organization' do
          expect(chef_run).to remove_chef_server_organization(name)
        end
      end

      context 'an organization that already exists' do
        include_context description

        it_behaves_like 'any property set'

        it 'executes the correct org-create command' do
          expect(chef_run).to run_execute(
            "Delete Chef Server organization: 'otherorg'"
          ).with(command: 'chef-server-ctl org-delete otherorg')
        end
      end

      context 'a all default properties' do
        include_context description

        it_behaves_like 'any property set'

        it 'does not execute an org-create command' do
          expect(chef_run).to_not run_execute(
            "Delete Chef Server organization: 'myorg'"
          )
        end
      end
    end
  end
end
