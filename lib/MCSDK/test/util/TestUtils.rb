require_relative('../../test/util/TestConstants')

module Mastercard
  module Util

    class TestUtils
      def get_private_key(environment)
        if environment.upcase == 'PRODUCTION'
          OpenSSL::PKCS12.new(File.open(PRODUCTION_PRIVATE_KEY_PATH),PRODUCTION_PRIVATE_KEY_PASSWORD).key
        else
          OpenSSL::PKCS12.new(File.open(SANDBOX_PRIVATE_KEY_PATH),SANDBOX_PRIVATE_KEY_PASSWORD).key
        end
      end
    end

  end
end


