require 'MCApi/MCApi.rb'
include MCApi

class TestController < ApplicationController
  # GET /test_money_send
  def money_send

    mss = MoneySendService.new
    mss.setup()

    sender_name = "Gaurav Arora"
    receiver_name = "Pooja Gupta"
    receiver_phone = "1800639426"

    sender_line1 = '123 Main Street'
    sender_line2 = '#5A'
    sender_city = 'Arlington'
    sender_country_subdivision = 'VA'
    sender_postal_code = '22207'
    sender_country = 'USA'
    sender_address = mss.create_sender_address(sender_line1, sender_line2, sender_city, sender_country_subdivision, sender_postal_code, sender_country)

    account_number = '5184680430000006' 
    expiry_month = '11'
    expiry_year = '2015'
    funding_card = mss.create_funding_card(account_number, expiry_month, expiry_year)

    value = rand(2**5..2**12).to_s
    currency = "840"
    funding_amount = mss.create_funding_amount(value, currency)

    line1 = 'Pueblo Street'
    line2 = 'PO BOX 12'
    city = 'El PASO'
    country_subdivision = 'TX'
    postal_code = '79906'
    country = 'USA'
    receiver_address = mss.create_receiver_address(line1, line2, city, country_subdivision, postal_code, country)

    account_number_receiver = '5184680430000014'
    receiving_card = mss.create_receiving_card(account_number_receiver)

    name = 'My Local Bank'
    card_acceptor_city = 'Saint Louis'
    card_acceptor_state = 'MO'
    card_acceptor_postal_code = '63101'
    card_acceptor_country = 'USA'
    card_acceptor = mss.create_card_acceptor(name, card_acceptor_city,card_acceptor_state, card_acceptor_postal_code, card_acceptor_country)

    recieving_value = rand(2**5..2**12).to_s
    recieving_currency = "484"
    receiving_amount = mss.create_receiving_amount(recieving_value, recieving_currency)

    transfer_request = mss.create_transfer_request(sender_name, receiver_name ,receiver_phone, sender_address, funding_card, funding_amount, receiver_address, receiving_card, card_acceptor, receiving_amount)
#######################################################################################################################
    payment_request = mss.create_payment_request(sender_name, sender_address, receiving_card, card_acceptor, receiving_amount)
    Rails.logger.info "Payment Data:" + payment_request.transaction_reference
    Rails.logger.info "Transfer Data:" + transfer_request.transaction_reference
    @transfer, @payment_request = mss.process_transaction(transfer_request, payment_request)
  end
end


   #     assert(transfer.transaction_reference.to_i > 0, 'true')
  #      assert(transfer.transaction_history.transaction[0] != nil, 'true')
 #       assert(transfer.transaction_history.transaction[0].response.code.to_i == 00, 'true')
#        assert(transfer.transaction_history.transaction[1].response.code.to_i == 00, 'true')

#        assert(payment_request.request_id.to_i > 0, 'true')
#        assert(payment_request.transaction_history.transaction != nil, 'true')
