# Encoding: UTF-8

require_relative '../spec_helper'

describe 'maitred::default' do
  let(:version) { nil }
  let(:config) { nil }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      node.set['maitred']['app']['version'] = version unless version.nil?
      node.set['maitred']['config'] = config unless config.nil?
    end
  end
  let(:converge) { runner.converge(described_recipe) }

  context 'default attributes' do
    cached(:chef_run) { converge }

    it 'creates a basic chef_server' do
      expect(chef_run).to create_chef_server('default')
        .with(version: :latest, config: {})
    end
  end

  context 'an overridden version attribute' do
    let(:version) { '1.2.3' }
    cached(:chef_run) { converge }

    it 'creates a chef_server with the specified version' do
      expect(chef_run).to create_chef_server('default')
        .with(version: '1.2.3', config: {})
    end
  end

  context 'an overridden config attribute' do
    let(:config) { { test: 'example' } }
    cached(:chef_run) { converge }

    it 'creates a chef_server with the specified config' do
      expect(chef_run).to create_chef_server('default')
        .with(config: { 'test' => 'example' })
    end
  end

  context 'overridden version and config attributes' do
    let(:version) { '1.2.3' }
    let(:config) { { test: 'example' } }
    cached(:chef_run) { converge }

    it 'creates a chef_server with the specified version and config' do
      expect(chef_run).to create_chef_server('default')
        .with(version: '1.2.3', config: { 'test' => 'example' })
    end
  end
end
