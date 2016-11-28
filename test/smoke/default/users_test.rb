# encoding: utf-8
# frozen_string_literal: true

describe user('opscode') do
  it 'exists' do
    expect(subject).to exist
  end

  it 'has uid 303' do
    expect(subject.uid).to eq(303)
  end
end

describe user('opscode-pgsql') do
  it 'exists' do
    expect(subject).to exist
  end

  it 'has uid 304' do
    expect(subject.uid).to eq(304)
  end
end
