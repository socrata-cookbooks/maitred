# encoding: utf-8
# frozen_string_literal: true

require_relative '../chef_server_config'

shared_context 'resources::chef_server_config::debian' do
  include_context 'resources::chef_server_config'

  let(:platform) { 'debian' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
