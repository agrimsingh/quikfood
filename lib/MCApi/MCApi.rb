require_relative '../MCSDK/common/Environment'
require_relative '../MCSDK/services/moneysend/services/TransferService'
require_relative '../MCSDK/services/moneysend/domain/transfer/Transfer'
require_relative '../MCSDK/services/moneysend/domain/transfer/SenderAddress'
require_relative '../MCSDK/services/moneysend/domain/transfer/FundingCard'
require_relative '../MCSDK/services/moneysend/domain/transfer/FundingAmount'
require_relative '../MCSDK/services/moneysend/domain/transfer/ReceiverAddress'
require_relative '../MCSDK/services/moneysend/domain/transfer/ReceivingAmount'
require_relative '../MCSDK/services/moneysend/domain/transfer/CardAcceptor'
require_relative '../MCSDK/services/moneysend/domain/transfer/FundingMapped'
require_relative '../MCSDK/services/moneysend/domain/transfer/FundingAmount'
require_relative '../MCSDK/services/moneysend/domain/transfer/ReceivingMapped'
require_relative '../MCSDK/services/moneysend/domain/transfer/ReceivingCard'

require_relative 'MCApiUtils'

include Mastercard::Common
include Mastercard::Services::MoneySend
include MCApi::MCApiUtils

module MCApi
class MoneySendService
    def setup
        @service = TransferService.new(SANDBOX_CONSUMER_KEY, SetupUtils.new.get_private_key(SANDBOX), SANDBOX)
    end

    def process_transaction(transfer_request, payment_request)
        transfer = @service.get_transfer(transfer_request)
        payment_request = @service.get_transfer(payment_request)
        return transfer, payment_request
    end

    def create_transfer_request(sender_name, receiver_name, receiver_phone, sender_address, funding_card, funding_amount, receiver_address, receiving_card, card_acceptor, receiving_amount)
        transfer_request = create_base_transfer_request

        transfer_request.sender_name = sender_name
        transfer_request.receiver_name = receiver_name
        transfer_request.receiver_phone = receiver_phone

        transfer_request.sender_address = sender_address
        transfer_request.funding_card = funding_card
        transfer_request.funding_amount = funding_amount
        transfer_request.receiver_address = receiver_address
        transfer_request.receiving_card = receiving_card
        transfer_request.card_acceptor = card_acceptor
        transfer_request.receiving_amount = receiving_amount
        return transfer_request
    end

    def create_sender_address(line1, line2, city, country_subdivision, postal_code, country)
        sender_address = SenderAddress.new
        sender_address.line1 = line1
        sender_address.line2 = line2
        sender_address.city = city
        sender_address.country_subdivision = country_subdivision
        sender_address.postal_code = postal_code
        sender_address.country = country
        return sender_address
    end

    def create_funding_card(account_number, expiry_month, expiry_year)
        funding_card = FundingCard.new
        funding_card.account_number = account_number
        funding_card.expiry_month = expiry_month
        funding_card.expiry_year = expiry_year
        return funding_card
    end

    def create_funding_amount(value, currency)
        funding_amount = FundingAmount.new
        funding_amount.value = value    
        funding_amount.currency = currency
        return funding_amount
    end

    def create_receiver_address(line1, line2, city, country_subdivision, postal_code, country)
        receiver_address = ReceiverAddress.new
        receiver_address.line1 = line1
        receiver_address.line2 = line2
        receiver_address.city = city
        receiver_address.country_subdivision = country_subdivision
        receiver_address.postal_code = postal_code
        receiver_address.country = country
        return receiver_address
    end

    def create_receiving_card(account_number)
        receiving_card = ReceivingCard.new
        receiving_card.account_number = account_number
        return receiving_card
    end

    def create_receiving_amount(value, currency)
        receiving_amount = ReceivingAmount.new
        receiving_amount.value = value    
        receiving_amount.currency = currency#'484'
        return receiving_amount
    end

    def create_card_acceptor(name, city,state, postal_code, country)
        card_acceptor = CardAcceptor.new
        card_acceptor.name = name
        card_acceptor.city = city
        card_acceptor.state = state
        card_acceptor.postal_code = postal_code
        card_acceptor.country = country
        return card_acceptor
    end

   def create_payment_request(sender_name, sender_address, receiving_card, card_acceptor, receiving_amount)
        payment_request = create_base_payment_request
        payment_request.sender_name = sender_name

        payment_request.sender_address = sender_address
        payment_request.receiving_card = receiving_card
        payment_request.card_acceptor = card_acceptor
        payment_request.receiving_amount = receiving_amount
        return payment_request
    end

    def create_base_transfer_request()
        transfer_request = TransferRequest.new
        transfer_request.local_date = '1212'
        transfer_request.local_time = '161222'
        trans_ref = transaction_ref_generator
        transfer_request.transaction_reference = trans_ref

        transfer_request.funding_ucaf = 'MjBjaGFyYWN0ZXJqdW5rVUNBRjU=1111'
        transfer_request.funding_mastercard_assigned_id = '123456'

        transfer_request.channel = 'W'
        transfer_request.ucaf_support = 'false'
        transfer_request.ica = '009674'
        transfer_request.processor_id = '9000000442'
        transfer_request.routing_and_transit_number = '990442082'

        transfer_request.transaction_desc = 'P2P'
        transfer_request.merchant_id = '123456'
        return transfer_request
    end

    def create_base_payment_request()
        payment_request = PaymentRequest.new
        payment_request.local_date = '1212'
        payment_request.local_time = '161222'

        trans_ref = transaction_ref_generator
        payment_request.transaction_reference = trans_ref

        payment_request.ica = '009674'
        payment_request.processor_id = '9000000442'
        payment_request.routing_and_transit_number = '990442082'
        
        payment_request.transaction_desc = 'P2P'
        payment_request.merchant_id = '123456'
        return payment_request
    end
    def transaction_ref_generator
        a = 0
        loop do
          p a = rand(2**32..2**64-1).to_s
          a = a[0..a.length-1]
          break if a.length == 19
        end
        a
    end
end
end