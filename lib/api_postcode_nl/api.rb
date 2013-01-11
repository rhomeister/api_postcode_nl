#encoding: utf-8
module ApiPostcodeNl
  class API
    BASE_URL = "https://api.postcode.nl/rest/addresses/"

    class << self
      def get_url(postcode, house_number, house_number_addition = nil)
        "#{BASE_URL}/#{postcode}/#{house_number}" + ("/#{house_number_addition}" if house_number_addition)
      end

      def send(postcode, house_number, house_number_addition = nil)
        uri = URI.parse(get_url(postcode, house_number, house_number_addition))
        req = Net::HTTP::Get.new(uri.request_uri)
        req.basic_auth key, secret
        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
          http.request(req)
        }
        res.body
      end

      def parse(response)
        JSON.parse(response)
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
