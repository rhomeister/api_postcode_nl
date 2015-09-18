require 'helper'

class TestApiPostcodeNl < Test::Unit::TestCase
  class DummyFetcher
    def fetch(*_)
      OpenStruct.new(body: '{}')
    end
  end

  context 'API.address' do
    setup do
      ApiPostcodeNl::API.fetcher = DummyFetcher.new

      ApiPostcodeNl::API.key = 'some-api-key'
      ApiPostcodeNl::API.secret = 'super-secret'
    end

    should 'handle non-numerical house numbers when house_number_addition is nil' do
      ApiPostcodeNl::API.address('1000AA', 'Foo')
    end
  end
end
