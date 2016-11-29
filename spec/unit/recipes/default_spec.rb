# encoding: utf-8
# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'maitred::default' do
  %i[
    version opscode_user opscode_uid postgres_user postgres_uid config
  ].each do |i|
    let(i) { nil }
  end
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      %i[
        version opscode_user opscode_uid postgres_user postgres_uid
      ].each do |a|
        node.set['maitred']['app'][a] = send(a) unless send(a).nil?
      end
      node.set['maitred']['config'] = config unless config.nil?
    end
  end
  let(:converge) { runner.converge(described_recipe) }

  shared_examples_for 'any attributes' do
    it 'creates a chef_server with the expected properties' do
      expect(chef_run).to create_chef_server('default').with(
        version: version.nil? ? :latest : version,
        opscode_user: opscode_user.nil? ? 'opscode' : opscode_user,
        opscode_uid: opscode_uid.nil? ? 303 : opscode_uid,
        postgres_user: postgres_user.nil? ? 'opscode-pgsql' : postgres_user,
        postgres_uid: postgres_uid.nil? ? 304 : postgres_uid
      )
    end
  end

  context 'default attributes' do
    cached(:chef_run) { converge }

    it_behaves_like 'any attributes'
  end

  context 'an overridden version attribute' do
    let(:version) { '1.2.3' }
    cached(:chef_run) { converge }

    it_behaves_like 'any attributes'
  end

  context 'an overridden opscode user attribute' do
    let(:opscode_user) { 'not_opscode' }
    cached(:chef_run) { converge }

    it_behaves_like 'any attributes'
  end

  context 'an overridden opscode UID attribute' do
    let(:opscode_uid) { 31 }
    cached(:chef_run) { converge }

    it_behaves_like 'any attributes'
  end

  context 'an overridden postgres user attribute' do
    let(:postgres_user) { 'not_postgres' }
    cached(:chef_run) { converge }

    it_behaves_like 'any attributes'
  end

  context 'an overridden postgres UID attribute' do
    let(:postgres_uid) { 32 }
    cached(:chef_run) { converge }

    it_behaves_like 'any attributes'
  end

  context 'an overridden config attribute' do
    let(:config) { { test: 'example' } }
    cached(:chef_run) { converge }

    it_behaves_like 'any attributes'
  end
end
