module ApiPostcodeNl
  class InvalidPostcodeException < Exception; end
  class InvalidHouseNumberException < InvalidPostcodeException; end
  class AddressNotFoundException < InvalidPostcodeException; end
  class PostcodeTooLongException < InvalidPostcodeException; end
end
