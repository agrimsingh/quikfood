require 'MCApi/MCApi.rb'
require 'simplify'
include MCApi

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => :withdraw_payments

  def sales
    @orders = Order.all.where(seller: current_user).order("created_at DESC")
  end

  def purchases
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end

  # GET /orders/new
  def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user

    @order.listing_id = @listing.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => (@listing.price * 100).floor,
        :currency => "usd",
        :card => token
        )
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end

    transfer = Stripe::Transfer.create(
      :amount => (@listing.price * 95).floor,
      :currency => "usd",
      :recipient => @seller.recipient
      )

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_url, notice: "Thanks for ordering!" }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
 def withdraw_payments
        mss = MoneySendService.new
        mss.setup()

        sender_name = "QuikFood Enterprise"
        receiver_name = "John Doe" #logger in user name
        receiver_phone = "1800639426"

        sender_line1 = '123 Main Street'
        sender_line2 = '#5A'
        sender_city = 'Arlington'
        sender_country_subdivision = 'VA'
        sender_postal_code = '22207'
        sender_country = 'USA'
        sender_address = mss.create_sender_address(sender_line1, sender_line2, sender_city, sender_country_subdivision, sender_postal_code, sender_country)

        account_number = '5184680430000261'
        expiry_month = '11'
        expiry_year = '2015'
        funding_card = mss.create_funding_card(account_number, expiry_month, expiry_year)


        value = (current_user.total_earnings.to_f * 100).to_i.to_s
        currency = "840"
        funding_amount = mss.create_funding_amount(value, currency)

        line1 = 'Pueblo Street'
        line2 = 'PO BOX 12'
        city = 'El PASO'
        country_subdivision = 'TX'#'Singapore'
        postal_code = '79906'
        country = 'USA'
        receiver_address = mss.create_receiver_address(line1, line2, city, country_subdivision, postal_code, country)

        account_number_receiver = '5184680430000279'
        receiving_card = mss.create_receiving_card(account_number_receiver)

        name = 'My Local Bank'
        card_acceptor_city = 'Saint Louis'
        card_acceptor_state = 'MO'
        card_acceptor_postal_code = '63101'
        card_acceptor_country = 'USA'
        card_acceptor = mss.create_card_acceptor(name, card_acceptor_city,card_acceptor_state, card_acceptor_postal_code, card_acceptor_country)

        recieving_value = (current_user.total_earnings.to_f * 100).to_i.to_s
        #value from user accountrand(2**5..2**12).to_s
        recieving_currency = "484"
        receiving_amount = mss.create_receiving_amount(recieving_value, recieving_currency)

        transfer_request = mss.create_transfer_request(sender_name, receiver_name ,receiver_phone, sender_address, funding_card, funding_amount, receiver_address, receiving_card, card_acceptor, receiving_amount)
    #######################################################################################################################
        payment_request = mss.create_payment_request(sender_name, sender_address, receiving_card, card_acceptor, receiving_amount)

        @transfer, @payment_request = mss.process_transaction(transfer_request, payment_request)
        # if transaction successful..show that page, and deduct from account
        current_user.total_earnings =  0
        current_user.save
        flash["info"]  = 'You have withdrawn Money from your Account.' 
       redirect_to :action => 'sales'        
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :city, :state)
    end
end
