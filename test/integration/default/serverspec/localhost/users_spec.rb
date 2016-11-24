# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'maitred::default::app' do
  describe user('opscode') do
    it 'exists' do
      expect(subject).to exist
    end

    it 'has uid 303' do
      expect(subject).to have_uid(303)
    end
  end

  describe user('opscode-pgsql') do
    it 'exists' do
      expect(subject).to exist
    end

    it 'has uid 304' do
      expect(subject).to have_uid(304)
    end
  end
end
