# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::chef_server_system_user' do
  include_context 'resources'

  let(:resource) { 'chef_server_system_user' }
  let(:properties) { {} }
  let(:name) { 'example' }

  shared_context 'the :create action' do
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_examples_for 'any platform' do
    context 'the :create action' do
      include_context description

      it 'creates the user' do
        expect(chef_run).to create_user('example')
          .with(uid: 123, system: true, home: '/tmp/example')
      end

      it 'uploads the user to a data bag' do
        expect(chef_run).to run_ruby_block('Upload user to data bag')
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes the user' do
        expect(chef_run).to remove_user('example')
      end
    end
  end
end
