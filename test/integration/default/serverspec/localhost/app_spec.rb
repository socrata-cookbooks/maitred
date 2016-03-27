# Encoding: UTF-8

require_relative '../spec_helper'

describe 'maitred::default::app' do
  describe package('chef-server') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe user('opscode') do
    it 'exists' do
      expect(subject).to exist
    end

    it 'has uid 142' do
      expect(subject).to have_uid(142)
    end
  end

  describe user('opscode-pgsql') do
    it 'exists' do
      expect(subject).to exist
    end

    it 'has uid 143' do
      expect(subject).to have_uid(143)
    end
  end

  describe file('/data') do
    it 'exists' do
      expect(subject).to be_directory
    end
  end

  %w(/etc/opscode/server.d /var/opt/opscode).each do |d|
    describe file(d) do
      it 'is a symlink to /data' do
        expect(subject).to be_linked_to(File.join('/data', d))
      end
    end

    describe file(File.join('/data', d)) do
      it 'exists' do
        expect(subject).to be_directory
      end

      it 'is owned by the opscode user' do
        expect(subject).to be_owned_by('opscode')
      end
    end
  end
end
