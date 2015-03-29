require 'MCApi/MCApi.rb'
require 'simplify'
include MCApi

class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:seller, :new, :create, :edit, :update, :destroy]
  before_filter :check_user, only: [:edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => :withdraw_payments
  
  def seller
    @listings = Listing.where(user: current_user).order("created_at DESC")
  end

  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all.order("created_at DESC")
  end

  def top_up
    current_user.credits_left =  current_user.credits_left + 100
    current_user.save
    flash["info"]  = 'Credits Added to your account.' 
    redirect_to :action => 'index'
  end
  def buy_card
    seller = User.find(params[:reference].to_i)
    seller.total_earnings = seller.total_earnings + (params[:amount].to_f/100)
    flash["info"]  = 'Your tasty meal will be with you shortly.'
    redirect_to :action => 'index'
  end
  def buy_credits
    seller = User.find(params[:reference].to_i)
    seller.total_earnings = seller.total_earnings + (params[:amount].to_f)
    seller.save
    current_user.credits_left =  current_user.credits_left - (params[:amount].to_f)
    current_user.save
    
    @order = Order.new()
    @order.address="210 Bukit Timah Road"
    @order.city="Singapore"
    @order.state="Singapore"
    
    @order.listing_id = params[:id].to_i
    @order.buyer_id = current_user.id
    @order.seller_id = seller.id

    @order.save

    flash["info"]  = 'Your tasty meal will be with you shortly.'
    redirect_to :action => 'index'
  end
  # GET /listings/1
  # GET /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id

    #if current_user.recipient.blank?
    #  Stripe.api_key = ENV["STRIPE_API_KEY"]
    #  token = params[:stripeToken]

    #  recipient = Stripe::Recipient.create(
    #    :name => current_user.name,
    #    :type => "individual",
    #    :bank_account => token
    #    )

    #  current_user.recipient = recipient.id
    #  current_user.save
    #end

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render action: 'show', status: :created, location: @listing }
      else
        format.html { render action: 'new' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url }
      format.json { head :no_content }
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


        value = params[:withdraw_amount]#value from User Account rand(2**5..2**12).to_s
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

        recieving_value = params[:withdraw_amount] #value from user accountrand(2**5..2**12).to_s
        recieving_currency = "484"
        receiving_amount = mss.create_receiving_amount(recieving_value, recieving_currency)

        transfer_request = mss.create_transfer_request(sender_name, receiver_name ,receiver_phone, sender_address, funding_card, funding_amount, receiver_address, receiving_card, card_acceptor, receiving_amount)
    #######################################################################################################################
        payment_request = mss.create_payment_request(sender_name, sender_address, receiving_card, card_acceptor, receiving_amount)

        @transfer, @payment_request = mss.process_transaction(transfer_request, payment_request)
        # if transaction successful..show that page, and deduct from account
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:name, :description, :price, :image)
    end

    def check_user
      if current_user != @listing.user
        redirect_to root_url, alert: "Sorry, this listing belongs to someone else"
      end
    end
end
