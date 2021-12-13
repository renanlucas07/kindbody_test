# frozen_string_literal: true

require 'active_support'
require 'rake'
require 'rspec'
require 'faraday'
require 'json'
require 'byebug'
require 'yaml'
require 'awesome_print'

# Service to find clinics within given radius from given zip code
class NearbyClinicsService
  attr_reader :zipcode, :radius, :units

  def initialize(zipcode, radius, units = 'mile')
    @zipcode = zipcode
    @radius  = radius
    @units   = units
  end

  def call
    # 1. Get list of ZIP codes in radius from starting zip code point
    extract_zip_codes_from_api
    return [] unless @extracted_zips_from_api

    # 2. find all ZIP codes in the DB that match the response, and sort by tier ASC
    extract_zip_codes_from_db

    # 3. Format response then sort by tier and distance
    format_response(@extracted_zips_from_db).sort_by { |z| [z[:tier], z[:distance]] }
  end

  private

  def format_response(sorted_zips)
    sorted_zips.map do |item|
      {
        name: item.name,
        address: item.address,
        city: item.city,
        state: item.state,
        distance: @extracted_zips_from_api[:zip_codes_with_distance][item.zipcode],
        tier: item.tier,
        contact_email: item.contact_email,
        contact_name: item.contact_name
      }
    end
  end

  def extract_zip_codes_from_api
    call_zip_codes_api
    return nil unless @zip_data

    zip_codes_distance = {}
    @zip_data['zip_codes'].each { |z| zip_codes_distance[z['zip_code']] = z['distance'] }

    @extracted_zips_from_api = {
      zip_codes: @zip_data['zip_codes'].map(&->(z) { z['zip_code'] }),
      zip_codes_with_distance: zip_codes_distance
    }
  end

  def call_zip_codes_api
    url = "https://www.zipcodeapi.com/rest/#{ENV['ZIP_CODE_API_KEY']}/radius.json/#{zipcode}/#{radius}/#{units}"
    zip_response = Faraday.get(url)
    return nil unless zip_response.success?

    @zip_data = JSON.parse(zip_response.body)
  end

  def extract_zip_codes_from_db
    zipcodes = @extracted_zips_from_api[:zip_codes]
    tier_values = %w[A B C]
    # @extracted_zips_from_db = PartnerClinic.where('zipcode IN (?)', zipcodes)
    #                                        .where('tier IN (?)', tier_values)
    #                                        .order('tier ASC')
    @extracted_zips_from_db = YAML.load_file('clinics.yml').map do |item|
      OpenStruct.new(
        {
          zipcode: item['zipcode'],
          tier: item['tier'],
          name: '',
          address: '',
          city: '',
          state: '',
          contact_email: '',
          contact_name: ''
        }
      )
    end
  end
end
