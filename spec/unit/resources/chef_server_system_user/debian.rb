# encoding: utf-8
# frozen_string_literal: true

require_relative '../chef_server_system_user'

shared_context 'resources::chef_server_system_user::debian' do
  include_context 'resources::chef_server_system_user'

  let(:platform) { 'debian' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
