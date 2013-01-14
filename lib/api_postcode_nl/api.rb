#encoding: utf-8
require 'net/http'
require 'net/https'
require 'json'
require 'api_postcode_nl/invalid_postcode_exception'

module ApiPostcodeNl
  class API
    BASE_URL = "https://api.postcode.nl/rest/addresses"
    
    class << self
      def get_url(postcode, house_number, house_number_addition = nil)
        postcode, house_number, house_number_addition = [postcode, house_number, house_number_addition].map{|c| c.to_s.delete(" ")}
        "#{BASE_URL}/#{postcode}/#{house_number}/#{house_number_addition}"
      end

      def send(postcode, house_number, house_number_addition = nil)
        uri = URI.parse(get_url(postcode, house_number, house_number_addition))
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        
        request = Net::HTTP::Get.new(uri.path)
        request.basic_auth key, secret
        result = http.start {|http|
          http.request(request)
        }
        handle_errors(result)
        
        result.body
      end
      
      def handle_errors(result)
        if result.is_a?(Net::HTTPNotFound)
          raise ApiPostcodeNl::InvalidPostcodeException, JSON.parse(result.body)["exception"]
        end
        #puts result.code.class
        #puts result.message
        #puts result.body
      end

      def parse(response)
        result = {}
        parsed_response = JSON.parse(response)
        { 
          street_name: parsed_response["street"],
          house_number: parsed_response["houseNumber"],
          postcode: parsed_response["postcode"],
          city:  parsed_response["city"],
          municipality: parsed_response["municipality"],
          province: parsed_response["province"],
          latitude: parsed_response["latitude"],
          longitude: parsed_response["longitude"],
          address_type: parsed_response["addressType"],
          purpose: parsed_response["purpose"],
          area: parsed_response["surfaceArea"],
          house_number_additions: parsed_response["houseNumberAdditions"]
        }
      end

      def address(postcode, house_number, house_number_addition = nil)
        parse(send(postcode, house_number, house_number_addition))
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
