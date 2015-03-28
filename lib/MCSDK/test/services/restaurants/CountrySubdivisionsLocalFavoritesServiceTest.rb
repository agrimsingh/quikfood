require_relative '../../util/TestConstants'
require_relative '../../util/TestUtils'
require_relative '../../../services/restaurants/services/CountrySubdivisionsLocalFavoritesService'
require_relative '../../../services/restaurants/domain/options/CountrySubdivisionsLocalFavoritesRequestOptions'
require_relative '../../../common/Environment'
require 'test/unit'

include Mastercard::Common
include Mastercard::Util
include Mastercard::Services::Restaurants

class CountrySubdivisionsLocalFavoritesServiceTest < Test::Unit::TestCase

  def setup
    @service = CountrySubdivisionsLocalFavoritesService.new(SANDBOX_CONSUMER_KEY, TestUtils.new.get_private_key(SANDBOX), SANDBOX)
  end

  def test_service
    options = CountrySubdivisionsLocalFavoritesRequestOptions.new('USA')
    country_subdivisions = @service.get_country_subdivisions(options)
    assert(country_subdivisions.country_subdivision.size > 0, 'true')
    assert(country_subdivisions != nil, 'true')
  end

end