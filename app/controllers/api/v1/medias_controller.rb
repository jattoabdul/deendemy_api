class Api::V1::MediasController < Api::V1::ApplicationController
  include ErrorSerializer
  before_action :set_media, only: [:show, :update, :destroy]

  # GET /medias
  def index
    # TODO: check that user is admin
    @medias = Media.all

    render json: @medias
  end

  # GET /accounts/:account_id/medias
  def my_media
    @medias = Media.where(user_id: params[:account_id])

    render json: @medias
  end

  # GET /medias/1
  def show
    # TODO: check that media belongs to user unless user is admin
    render json: @media
  end

  # POST /medias
  def create
    @media = Media.new(media_params)

    if @media.save
      render json: @media, status: :created
    else
      render json: ErrorSerializer.serialize(@media.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /medias/1
  def update
    # TODO: allow only update of owned media and  do not allow update of item
    if @media.update(media_params)
      render json: @media
    else
      render json: ErrorSerializer.serialize(@media.errors), status: :unprocessable_entity
    end
  end

  # DELETE /medias/1
  def destroy
    # TODO: check that user is owner of media or admin and delete file from s3
    @media.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media
      @media = Media.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def media_params
      params.permit(:user_id, :type, :title, :description, :item, :message_id, :is_deleted)
    end
end
