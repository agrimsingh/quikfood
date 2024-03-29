
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
    refs = URI.unescape(params[:reference]).split("|")
    seller = User.find(refs[0].to_i)
    seller.total_earnings = seller.total_earnings + Listing.find(refs[1].to_i).price
    seller.save 

    @order = Order.new()
    @order.address="210 Bukit Timah Road"
    @order.city="Singapore"
    @order.state="Singapore"
    
    @order.listing_id = refs[1].to_i
    @order.buyer_id = current_user.id
    @order.seller_id = seller.id

    @order.save


    flash["info"]  = 'Your tasty meal will be with you shortly.'
    redirect_to :action => 'index'
  end

  def buy_credits
    seller = User.find(params[:reference].to_i)
    seller.total_earnings = seller.total_earnings + Listing.find(params[:id].to_i).price
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
