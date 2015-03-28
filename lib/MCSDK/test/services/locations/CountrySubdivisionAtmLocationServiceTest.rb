require_relative '../../util/TestConstants'
require_relative '../../util/TestUtils'
require_relative '../../../services/locations/atms/services/CountrySubdivisionAtmLocationService'
require_relative '../../../services/locations/domain/common/Countries/Country'
require_relative '../../../services/locations/domain/common/countries/countries'
require_relative '../../../services/locations/domain/options/atms/CountrySubdivisionAtmLocationRequestOptions'
require_relative '../../../services/locations/domain/options/merchants/Details'
require_relative '../../../services/locations/domain/common/Countries/Country'
require_relative '../../../common/Environment'
require 'test/unit'

include Mastercard::Common
include Mastercard::Util
include Mastercard::Services::Locations

class CountrySubdivisionAtmLocationServiceTest < Test::Unit::TestCase

  def setup
    @service = CountrySubdivisionAtmLocationService.new(SANDBOX_CONSUMER_KEY, TestUtils.new.get_private_key(SANDBOX), SANDBOX)
  end

  def test_service
    options = CountrySubdivisionAtmLocationRequestOptions.new
    options.country = 'USA'
    country_subdivisions = @service.get_country_subdivisions(options)
    assert(country_subdivisions.country_subdivision.size > 0, 'true')
    assert(country_subdivisions != nil, 'true')
  end

end