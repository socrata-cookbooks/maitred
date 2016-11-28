# encoding: utf-8
# frozen_string_literal: true

describe command('chef-server-ctl status') do
  it 'indicates Chef Server is running' do
    expect(subject.exit_status).to eq(0)
  end
end
