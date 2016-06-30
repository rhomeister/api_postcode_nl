require 'helper'

class TestApiPostcodeNl < Minitest::Test
  class DummyFetcher
    def fetch(*_)
      OpenStruct.new(body: '{}')
    end
  end

  describe 'API.address' do
    before do
      ApiPostcodeNl::API.fetcher = DummyFetcher.new

      ApiPostcodeNl::API.key = 'some-api-key'
      ApiPostcodeNl::API.secret = 'super-secret'
    end

    it 'handle non-numerical house numbers when house_number_addition is nil' do
      ApiPostcodeNl::API.address('1000AA', 'Foo')
    end
  end
end
