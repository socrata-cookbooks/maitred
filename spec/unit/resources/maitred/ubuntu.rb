# encoding: utf-8
# frozen_string_literal: true

require_relative 'debian'

shared_context 'resources::maitred::ubuntu' do
  include_context 'resources::maitred::debian'

  let(:platform) { 'ubuntu' }

  shared_examples_for 'any Ubuntu platform' do
    it_behaves_like 'any Debian platform'
  end
end
