# frozen_string_literal: true

require 'active_support/all'
require 'webmock/rspec'
require 'yaml'

PROJECT_ROOT = File.expand_path('..', __dir__)

Dir.glob(File.join(PROJECT_ROOT, '*.rb')).each do |file|
  autoload File.basename(file, '.rb').camelize, file
end

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stubbed_response = YAML.load_file('spec/api_response_mock.yml').map do |item|
      {
        zip_code: item['zip_code'],
        distance: item['distance']
      }
    end
    stub_request(:get, 'https://www.zipcodeapi.com/rest/zFcGz2AlgJGdNdOS0Z6rL5PKAn2DhIpAm5fsFzHqIIvjlyNgtpHO56jQtm6IKMKw/radius.json/10016/5/mile').
      with(headers: { 'Accept' => '*/*' }).
      to_return(status: 200,
                headers: {},
                body: {
                  'zip_codes' => stubbed_response
                }.to_json)
  end
end
