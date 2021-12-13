# frozen_string_literal: true

require 'spec_helper'
require_relative '../nearby_clinics_service'

describe 'NearbyClinicsService' do
  describe '#call' do
    before(:each) do
      @response = NearbyClinicsService.new('10016', '5').call
    end

    it {
      expect(@response).to be_kind_of(Array)
      expect(@response).not_to be_empty
    }

    it 'should be ordered by tier and distance' do
      
    end
  end
end
