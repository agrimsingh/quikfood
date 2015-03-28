require_relative '../../util/TestConstants'
require_relative '../../util/TestUtils'
require_relative '../../../services/locations/merchants/services/CountryMerchantLocationService'
require_relative '../../../services/locations/domain/common/Countries/Country'
require_relative '../../../services/locations/domain/common/countries/countries'
require_relative '../../../services/locations/domain/options/merchants/CountryMerchantLocationRequestOptions'
require_relative '../../../services/locations/domain/options/merchants/Details'
require_relative '../../../services/locations/domain/common/Countries/Country'
require_relative '../../../common/Environment'
require 'test/unit'

include Mastercard::Common
include Mastercard::Util
include Mastercard::Services::Locations

class CountryMerchantLocationServiceTest < Test::Unit::TestCase

  def setup
    @service = CountryMerchantLocationService.new(SANDBOX_CONSUMER_KEY, TestUtils.new.get_private_key(SANDBOX), SANDBOX)
  end

  def test_country_merchant_location_service
    options = CountryMerchantLocationRequestOptions.new(Details::ACCEPTANCE_PAYPASS)
    countries = @service.get_countries(options)
    assert(countries.country.size > 0, 'true')
    assert(countries != nil, 'true')
  end

end