# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::chef_server_component_config' do
  include_context 'resources'

  let(:resource) { 'chef_server_component_config' }
  %i[component config].each { |i| let(i) { nil } }
  let(:properties) { { component: component, config: config } }

  shared_context 'the :create action' do
  end

  shared_context 'the :delete action' do
    let(:action) { :delete }
  end

  shared_context 'properties for a bookshelf component' do
    let(:component) { :bookshelf }
    let(:config) do
      {
        enable: false,
        access_key_id: '12345',
        secret_access_key: 'abc123',
        vip: 's3-test.amazonaws.com',
        external_url: 'https://s3-test.amazonaws.com'
      }
    end
  end

  shared_examples_for 'any platform' do
    context 'the :create action' do
      include_context description

      context 'properties for a bookshelf component' do
        include_context description

        it 'renders the expected config file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            bookshelf['enable'] = false
            bookshelf['access_key_id'] = '12345'
            bookshelf['secret_access_key'] = 'abc123'
            bookshelf['vip'] = 's3-test.amazonaws.com'
            bookshelf['external_url'] = 'https://s3-test.amazonaws.com'
          EOH
          expect(chef_run).to create_file('/etc/opscode/server.d/bookshelf.rb')
            .with(content: expected)
        end
      end
    end

    context 'the :delete action' do
      include_context description

      context 'properties for a bookshelf component' do
        include_context description

        it 'deletes the config file' do
          expect(chef_run).to delete_file('/etc/opscode/server.d/bookshelf.rb')
        end
      end
    end
  end
end
