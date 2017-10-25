require 'net/http'
require 'net/https'
require 'json'
require 'active_support'
require 'active_support/core_ext/object'
require 'api_postcode_nl/exceptions'

module ApiPostcodeNl
  class API
    class Fetcher
      def fetch(uri, key, secret)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.path)
        request.basic_auth key, secret
        result = http.start do |http|
          http.request(request)
        end
        result
      end
    end

    BASE_URL = 'https://api.postcode.nl/rest/addresses'
    NIL_RESULT_CODE = 'api_postcode_nl_NIL_RESULT_CODE'

    class << self
      def get_url(postcode, house_number, house_number_addition = nil)
        postcode, house_number, house_number_addition = [postcode, house_number, house_number_addition].map{ |c| c.to_s.delete(' ') }
        "#{BASE_URL}/#{postcode}/#{house_number}/#{house_number_addition}"
      end

      def fetch(postcode, house_number, house_number_addition = nil)
        uri = URI.parse(get_url(postcode, house_number, house_number_addition))
        result = fetcher.fetch(uri, key, secret)

        handle_errors(result)

        result.body
      end

      def handle_errors(result)
        if result.is_a?(Net::HTTPNotFound)
          body = JSON.parse(result.body)
          case body['exceptionId']
          when 'PostcodeNl_Controller_Address_InvalidHouseNumberException'
            raise ApiPostcodeNl::InvalidHouseNumberException, body['exception']
          when 'PostcodeNl_Controller_Address_PostcodeTooLongException'
            raise ApiPostcodeNl::PostcodeTooLongException, body['exception']
          when 'PostcodeNl_Service_PostcodeAddress_AddressNotFoundException'
            raise ApiPostcodeNl::AddressNotFoundException, body['exception']
          else
            raise ApiPostcodeNl::InvalidPostcodeException, body['exception']
          end
        end
      end

      def parse(response)
        result = {}
        parsed_response = JSON.parse(response)
        {
          street_name: parsed_response['street'],
          house_number: parsed_response['houseNumber'],
          postcode: parsed_response['postcode'],
          city:  parsed_response['city'],
          municipality: parsed_response['municipality'],
          province: parsed_response['province'],
          latitude: parsed_response['latitude'],
          longitude: parsed_response['longitude'],
          address_type: parsed_response['addressType'],
          purpose: parsed_response['purpose'],
          area: parsed_response['surfaceArea'],
          house_number_additions: parsed_response['houseNumberAdditions'],
          house_number_addition: parsed_response['houseNumberAddition']
        }
      end

      def cache_key(postcode, house_number, house_number_addition)
        "api_postcode_nl_#{postcode.to_s.downcase}_#{house_number.to_s.downcase}_#{house_number_addition.to_s.downcase}"
      end

      def address(postcode, house_number, house_number_addition = nil)
        if house_number_addition.blank? && house_number
          # attempt to get a house_number_addition from the house number
          house_number = house_number.to_s
          number = house_number.split(/[^0-9]/)[0]
          if number
            house_number_addition = house_number.sub(number, '')
            house_number = number
          end
        end

        if postcode.blank? || house_number.blank?
          return nil
        end

        key = cache_key(postcode, house_number, house_number_addition)
        if cache && result = cache.read(key)
          return nil if result == NIL_RESULT_CODE
          return result
        end

        result = parse(fetch(postcode, house_number, house_number_addition))

        cache.write(key, result ? result : NIL_RESULT_CODE, expires_in: 1.week) if cache

        result
      end

      def cache=(cache)
        @@cache = cache
      end

      def cache
        @@cache ||= nil
      end

      def fetcher=(fetcher)
        @@fetcher = fetcher
      end

      def fetcher
        @@fetcher ||= Fetcher.new
      end

      def key
        @@key
      end

      def key=(value)
        @@key = value
      end

      def secret
        @@secret
      end

      def secret=(value)
        @@secret = value
      end
    end
  end
end
