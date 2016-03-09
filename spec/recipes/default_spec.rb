# Encoding: UTF-8

require_relative '../spec_helper'

describe 'socrata-chef-server::default' do
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'creates a chef_server' do
    expect(chef_run).to create_chef_server('default')
  end
end
