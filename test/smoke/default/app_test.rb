# encoding: utf-8
# frozen_string_literal: true

describe package('chef-server-core') do
  it 'is installed' do
    expect(subject).to be_installed
  end
end

describe file('/data') do
  it 'exists' do
    expect(subject).to be_directory
  end
end

%w[/etc/opscode /var/opt/opscode].each do |d|
  describe file(d) do
    it 'is a symlink to /data' do
      expect(subject).to be_linked_to(File.join('/data', d))
    end
  end

  describe directory(File.join('/data', d)) do
    it 'exists' do
      expect(subject).to exist
    end

    it 'is owned by the opscode user' do
      expect(subject.owner).to eq('opscode')
    end
  end
end
