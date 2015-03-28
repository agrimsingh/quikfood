require_relative '../../util/TestConstants'
require_relative '../../util/TestUtils'
require_relative '../../../services/restaurants/services/CountriesLocalFavoritesService'
require_relative '../../../common/Environment'
require 'test/unit'

include Mastercard::Common
include Mastercard::Util
include Mastercard::Services::Restaurants

class CountriesLocalFavoritesServiceTest < Test::Unit::TestCase

  def setup
    @service = CountriesLocalFavoritesService.new(SANDBOX_CONSUMER_KEY, TestUtils.new.get_private_key(SANDBOX), SANDBOX)
  end

  def test_country_local_favorites_service
    countries = @service.get_countries()
    assert(countries.country.size > 0, 'true')
    assert(countries != nil, 'true')
  end

end