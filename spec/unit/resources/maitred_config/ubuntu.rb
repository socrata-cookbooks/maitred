# encoding: utf-8
# frozen_string_literal: true

require_relative 'debian'

shared_context 'resources::maitred_config::ubuntu' do
  include_context 'resources::maitred_config::debian'

  let(:platform) { 'ubuntu' }

  shared_examples_for 'any Ubuntu platform' do
    it_behaves_like 'any Debian platform'
  end
end
