# encoding: utf-8
# frozen_string_literal: true

require_relative '../maitred'

shared_context 'resources::maitred::debian' do
  include_context 'resources::maitred'

  let(:platform) { 'debian' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
