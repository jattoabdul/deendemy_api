class Api::V1::ChaptersController < Api::V1::ApplicationController
  before_action :set_chapter, only: [:show, :update, :destroy]

  # GET courses/:course_id/chapters
  def index
    @chapters = Chapter.all

    render json: @chapters
  end

  # GET courses/:course_id/chapters/1
  def show
    render json: @chapter
  end

  # POST courses/:course_id/chapters
  def create
    @chapter = Chapter.new(chapter_params)

    if @chapter.save
      render json: @chapter, status: :created, location: @chapter
    else
      render json: @chapter.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT courses/:course_id/chapters/1
  def update
    if @chapter.update(chapter_params)
      render json: @chapter
    else
      render json: @chapter.errors, status: :unprocessable_entity
    end
  end

  # DELETE courses/:course_id/chapters/1
  def destroy
    @chapter.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chapter_params
      params.require(:chapter).permit(:user_id, :title, :description, :public_url, :message_id, :is_deleted)
    end
end
