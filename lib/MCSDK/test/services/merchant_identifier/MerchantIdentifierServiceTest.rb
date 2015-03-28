require_relative '../../util/TestConstants'
require_relative '../../util/TestUtils'
require_relative '../../../services/merchant_identifier/MerchantIdentifierService'
require_relative '../../../services/merchant_identifier/domain/RequestOptions'
require_relative '../../../common/Environment'
require 'test/unit'

include Mastercard::Common
include Mastercard::Util
include Mastercard::Services::MerchantIdentifier

class MerchantIdentifierServiceTest < Test::Unit::TestCase

  def setup
      @service = MerchantIdentifierService.new(SANDBOX_CONSUMER_KEY, TestUtils.new.get_private_key(SANDBOX), SANDBOX)
  end

  def test_merchant_no_type
    merchant = RequestOptions.new('DIRECTSATELLITETV')
    response = @service.get_merchant_id(merchant)
    assert(response.returned_merchants != nil, 'true')
    assert(response.message != nil, 'true')
  end

  def test_merchant_exact_match
    merchant = RequestOptions.new('DIRECTSATELLITETV')
    merchant.set_type('ExactMatch')
    response = @service.get_merchant_id(merchant)
    assert(response.returned_merchants != nil, 'true')
    assert(response.message != nil, 'true')
  end

  def test_merchant_fuzzy_match
    merchant = RequestOptions.new('DIRECTSATELLITETV')
    merchant.set_type('FuzzyMatch')
    response = @service.get_merchant_id(merchant)
    assert(response.returned_merchants != nil, 'true')
    assert(response.message != nil, 'true')
  end

end
