# encoding: utf-8
# frozen_string_literal: true

require_relative '../ubuntu'

describe 'resources::maitred_config::ubuntu::14_04' do
  include_context 'resources::maitred_config::ubuntu'

  let(:platform_version) { '14.04' }

  it_behaves_like 'any Ubuntu platform'
end
