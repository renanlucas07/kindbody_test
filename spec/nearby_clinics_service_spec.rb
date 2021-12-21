# frozen_string_literal: true

require 'spec_helper'
require_relative '../nearby_clinics_service'

describe 'NearbyClinicsService' do
  context '#call' do
    let(:response) { NearbyClinicsService.new('10016', '5').call }
    let(:ordered_response) {
      [
        { name: '', address: '', city: '', state: '', distance: '3.52',  tier: 'A', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '4.549', tier: 'A', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '4.626', tier: 'A', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '3.073', tier: 'B', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '3.156', tier: 'B', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '3.206', tier: 'B', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '4.106', tier: 'B', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '2.955', tier: 'C', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '3.655', tier: 'C', contact_email: '', contact_name: '' },
        { name: '', address: '', city: '', state: '', distance: '4.931', tier: 'C', contact_email: '', contact_name: '' }
      ]
    }

    it {
      expect(response).to be_kind_of(Array)
      expect(response).not_to be_empty
    }

    it 'should be ordered by tier and distance' do
      expect(ordered_response).to eq(response)
    end
  end
end
