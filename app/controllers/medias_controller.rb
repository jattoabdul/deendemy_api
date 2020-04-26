class MediasController < ApplicationController
  before_action :set_media, only: [:show, :update, :destroy]

  # GET /medias
  def index
    @medias = Media.all

    render json: @medias
  end

  # GET /medias/1
  def show
    render json: @media
  end

  # POST /medias
  def create
    @media = Media.new(media_params)

    if @media.save
      render json: @media, status: :created, location: @media
    else
      render json: @media.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /medias/1
  def update
    if @media.update(media_params)
      render json: @media
    else
      render json: @media.errors, status: :unprocessable_entity
    end
  end

  # DELETE /medias/1
  def destroy
    @media.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media
      @media = Media.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def media_params
      params.require(:media).permit(:user_id, :type, :title, :description, :public_url, :message_id, :is_deleted)
    end
end
