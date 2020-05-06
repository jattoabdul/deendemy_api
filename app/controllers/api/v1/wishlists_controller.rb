class Api::V1::WishlistsController < Api::V1::ApplicationController
  before_action :set_wishlist, only: [:show]
  before_action :set_user, only: [:index, :show, :add_to_wishlist, :remove_from_wishlist]

  # GET /accounts/:account_id/wishlists
  def index
    @wishlists = Wishlist.all
    # TODO: paginate and return first 20

    render json: @wishlists
  end

  # GET /accounts/:account_id/wishlists/1
  def show
    bad_request_error('cannot view information for this wishlist') && return unless wishlist_owner_or_admin?
  
    render json: @wishlist
  end

  # POST /accounts/:account_id/wishlists/add
  def add_to_wishlist
    @courses = Course.find(wishlist_params[:items])
    @courses.each do |item|
      @user.wishlist.add(item)
    end

    if @user.wishlist.save
      render json: @user.wishlist, status: :accepted
    else
      render json: ErrorSerializer.serialize(@user.wishlist.errors), status: :unprocessable_entity
    end
  end

  # POST /accounts/:account_id/wishlists/remove
  def remove_from_wishlist
    @courses = Course.find(wishlist_params[:items])
    @courses.each do |item|
      @user.wishlist.remove(item)
    end
  
    if @user.wishlist.save
      render json: @user.wishlist, status: :accepted
    else
      render json: ErrorSerializer.serialize(@user.wishlist.errors), status: :unprocessable_entity
    end
  end

  private
    def set_wishlist
      @wishlist = Wishlist.find(params[:id])
    end

    def set_user
      @user = User.find(params[:account_id])
    end

    def wishlist_owner_or_admin?
       (@wishlist.user_id == current_api_v1_user.id) || (current_api_v1_user.roles.include?('admin') )
    end

    def wishlist_params
      # items is a list of course_ids
      params.require(:items)
      params.permit(items: [])
    end
end
