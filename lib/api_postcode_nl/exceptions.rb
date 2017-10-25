module ApiPostcodeNl
  class InvalidPostcodeException < RuntimeError; end
  class InvalidHouseNumberException < InvalidPostcodeException; end
  class AddressNotFoundException < InvalidPostcodeException; end
  class PostcodeTooLongException < InvalidPostcodeException; end
end
