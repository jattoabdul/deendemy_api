class Api::V1::ChaptersController < Api::V1::ApplicationController
  before_action :set_chapter, only: %i(show update destroy)
  before_action :set_course, only: %i(index create show update update_positions destroy)

  # GET courses/:course_id/chapters
  def index
    @chapters = Chapter.includes(%i(course lessons)).where(course_id: @course.id).order_by(position: :asc)

    render json: @chapters
  end

  # GET /chapters
  def all_chapters
    @chapters = Chapter.all

    render json: @chapters
  end

  # GET courses/:course_id/chapters/1
  def show
    render json: @chapter
  end

  # POST courses/:course_id/chapters
  def create
    @chapter = Chapter.new(chapter_params.merge(course_id: @course.id))

    if @chapter.save
      render json: @chapter, status: :created
    else
      render json: ErrorSerializer.serialize(@chapter.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT courses/:course_id/chapters/1
  def update
    bad_request_error('cannot update chapters for this course') && return unless course_owner_or_admin?
    if @chapter.update(chapter_update_params)
      render json: @chapter
    else
      render json: ErrorSerializer.serialize(@chapter.errors), status: :unprocessable_entity
    end
  end

  # POST courses/:course_id/chapters/positions
  def update_positions
    params.permit(positions: [])
    bad_request_error('Chapter positions cannot be empty') && return unless params[:positions].present?
    bad_request_error('cannot update position of chapters for this course') && return unless course_owner_or_admin?

    positions_hash = Hash[params[:positions].map.with_index.to_a]

    @chapters = Chapter.includes(%i(course lessons notifications events)).where(course_id: @course.id).find(params[:positions])
    @chapters.each do |chapter|
      chapter.update_attributes(position: positions_hash[chapter.id.to_s].to_i)
    end
    @chapters = Chapter.includes(%i(course lessons notifications events)).where(course_id: @course.id).order_by(position: :asc)

    render json: @chapters
  end

  # DELETE courses/:course_id/chapters/1
  def destroy
    bad_request_error('cannot delete chapter for this course') && return unless course_owner_or_admin?
    @chapter.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    def course_owner_or_admin?
      (@course.tutor_id == current_api_v1_user.id) || current_api_v1_user.roles.include?('admin') 
    end

    # Only allow a trusted parameter "white list" through.
    def chapter_params
      params.require(:chapter).permit(:title, :objective, :position)
    end

    def chapter_update_params
      params.require(:chapter).permit(:title, :objective)
    end
end
