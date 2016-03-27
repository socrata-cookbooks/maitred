# Encoding: UTF-8

require_relative '../spec_helper'

describe 'maitred::default::service' do
  describe command('chef-server-ctl status') do
    it 'indicates Chef Server is running' do
      expect(subject.exit_status).to eq(0)
    end
  end
end
