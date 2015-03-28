require_relative '../../util/TestConstants'
require_relative '../../util/TestUtils'
require_relative '../../../services/locations/merchants/services/MerchantCategoriesService'
require_relative '../../../services/locations/domain/categories/Categories'
require_relative '../../../common/environment'
require 'test/unit'

include Mastercard::Common
include Mastercard::Util
include Mastercard::Services::Locations

class MerchantCategoriesServiceTest < Test::Unit::TestCase

  def setup
    @service = MerchantCategoriesService.new(SANDBOX_CONSUMER_KEY, TestUtils.new.get_private_key(SANDBOX), SANDBOX)
  end

  def test_merchant_categories
    categories = @service.get_categories
    assert(categories.category.size > 0, 'true')
    assert(categories != nil, 'true')
  end

end