require_relative '../../util/TestConstants'
require_relative '../../util/TestUtils'
require_relative '../../../services/locations/merchants/services/CountrySubdivisionMerchantLocationService'
require_relative '../../../services/locations/domain/common/country_subdivisions/CountrySubdivision'
require_relative '../../../services/locations/domain/common/country_subdivisions/CountrySubdivisions'
require_relative '../../../services/locations/domain/options/merchants/CountrySubdivisionMerchantLocationRequestOptions'
require_relative '../../../services/locations/domain/options/merchants/Details'
require_relative '../../../services/locations/domain/common/Countries/Country'
require_relative '../../../common/environment'
require 'test/unit'

include Mastercard::Common
include Mastercard::Util
include Mastercard::Services::Locations

class CountrySubdivisionMerchantLocationServiceTest < Test::Unit::TestCase

  def setup
    @service = CountrySubdivisionMerchantLocationService.new(SANDBOX_CONSUMER_KEY, TestUtils.new.get_private_key(SANDBOX), SANDBOX)
  end

  def test_country_subdivision_service_with_paypass
    options = CountrySubdivisionMerchantLocationRequestOptions.new(Details::ACCEPTANCE_PAYPASS, 'USA')
    country_subdivisions = @service.get_country_subdivisions(options)
    assert(country_subdivisions.country_subdivision.size > 0, 'true')
    assert(country_subdivisions != nil, 'true')
  end

  def test_country_subdivision_service_with_offers
    options = CountrySubdivisionMerchantLocationRequestOptions.new(Details::OFFERS_EASYSAVINGS, 'USA')
    country_subdivisions = @service.get_country_subdivisions(options)
    assert(country_subdivisions.country_subdivision.size > 0, 'true')
    assert(country_subdivisions != nil, 'true')
  end

  def test_country_subdivision_service_with_prepaid_travel
    options = CountrySubdivisionMerchantLocationRequestOptions.new(Details::PRODUCTS_PREPAID_TRAVEL_CARD, 'USA')
    country_subdivisions = @service.get_country_subdivisions(options)
    assert(country_subdivisions.country_subdivision.size > 0, 'true')
    assert(country_subdivisions != nil, 'true')
  end

  def test_country_subdivision_service_with_repower
    options = CountrySubdivisionMerchantLocationRequestOptions.new(Details::TOPUP_REPOWER, 'USA')
    country_subdivisions = @service.get_country_subdivisions(options)
    assert(country_subdivisions.country_subdivision.size > 0, 'true')
    assert(country_subdivisions != nil, 'true')
  end

end

