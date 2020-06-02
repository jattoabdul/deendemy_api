class Api::V1::CartsController < Api::V1::ApplicationController
  before_action :set_cart, only: [:show]
  before_action :set_user, only: %i(index show add_to_cart remove_from_cart)

  # GET /accounts/:account_id/carts
  def index
    @carts = Cart.all
    # TODO: paginate and return first 20

    render json: @carts
  end

  # GET /accounts/:account_id/carts/:id
  def show
    bad_request_error('cannot view information for this cart') && return unless cart_owner_or_admin?
    
    render json: @cart
  end

  # POST /accounts/:account_id/carts/add
  def add_to_cart
    @courses = Course.find(cart_params[:items])
    @courses.each do |item|
      @user.cart.add(item)
    end

    @user.cart.reset_expiry
    if @user.cart.save
      render json: @user.cart, status: :accepted
    else
      render json: ErrorSerializer.serialize(@user.cart.errors), status: :unprocessable_entity
    end
  end

  # POST /accounts/:account_id/carts/remove
  def remove_from_cart
    @courses = Course.find(cart_params[:items])
    @courses.each do |item|
      @user.cart.remove(item)
    end
  
    @user.cart.expires_on = nil if @user.cart.items.size <= 0
    if @user.cart.save
      render json: @user.cart, status: :accepted
    else
      render json: ErrorSerializer.serialize(@user.cart.errors), status: :unprocessable_entity
    end
  end

  private
    def set_cart
      @cart = Cart.find(params[:id])
    end

    def set_user
      @user = User.find(params[:account_id])
    end

    def cart_owner_or_admin?
       (@cart.user_id == current_api_v1_user.id) || current_api_v1_user.roles.include?('admin') 
    end

    def cart_params
      # items is a list of course_ids
      params.require(:items)
      params.permit(items: [])
    end
end
