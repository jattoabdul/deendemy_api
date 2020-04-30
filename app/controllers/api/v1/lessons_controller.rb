class Api::V1::LessonsController < Api::V1::ApplicationController
  before_action :set_lesson, only: [:show, :update, :destroy]
  before_action :set_chapter, only: [:index, :create, :show, :update, :update_positions, :destroy]

  # GET courses/:course_id/chapters/:chapter_id/lessons
  def index
    @lessons = Lesson.includes([:chapter]).where(chapter_id: @chapter.id).order_by(position: :asc)

    render json: @lessons
  end

  # GET /lessons
  def all_lessons
    @chapters = Lesson.all

    render json: @lessons
  end

  # GET courses/:course_id/chapters/:chapter_id/lessons/1
  def show
    render json: @lesson
  end

  # POST courses/:course_id/chapters/:chapter_id/lessons
  def create
    @lesson = Lesson.new(lesson_params.merge(chapter_id: @chapter.id))

    if @lesson.save
      render json: @lesson, status: :created
    else
      render json: ErrorSerializer.serialize(@lesson.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT courses/:course_id/chapters/:chapter_id/lessons/1
  def update
    bad_request_error('cannot update lesson for this course chapters') && return unless course_owner_or_admin?
    if @lesson.update(lesson_update_params)
      render json: @lesson
    else
      render json: ErrorSerializer.serialize(@lesson.errors), status: :unprocessable_entity
    end
  end

   # POST courses/:course_id/chapters/chapter_id/lessons/positions
  def update_positions
    params.permit(positions: [])
    bad_request_error('Lesson positions cannot be empty') && return unless params[:positions].present?
    bad_request_error('cannot update position of lessons for this course chapter') && return unless course_owner_or_admin?

    positions_hash = Hash[params[:positions].map.with_index.to_a]

    @lessons = Lesson.includes([:chapter, :events, :notifications]).where(chapter_id: @chapter.id).find(params[:positions])
    @lessons.each do |lesson|
      lesson.update_attributes(position: positions_hash[lesson.id.to_s].to_i)
    end
    @lessons = Lesson.includes([:chapter, :events, :notifications]).where(chapter_id: @chapter.id).order_by(position: :asc)

    render json: @lessons
  end

  # DELETE courses/:course_id/chapters/:chapter_id/lessons/1
  def destroy
    bad_request_error('cannot delete chapter for this course') && return unless course_owner_or_admin?
    @lesson.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def set_chapter
      @chapter = Chapter.where(id: params[:chapter_id], course_id: params[:course_id]).first
    end

    def course_owner_or_admin?
      (@chapter.course.tutor_id == current_api_v1_user.id) || (current_api_v1_user.roles.include?('admin') )
    end

    # Only allow a trusted parameter "white list" through.
    def lesson_params
      params.require(:lesson).permit(:title, :description, :assessment_id, :content_id, :additional_resource_id, :prerequisite, :downloadable, :type, :can_discuss, :status, :position)
    end

    def lesson_update_params
      params.require(:lesson).permit(:title, :description, :assessment_id, :content_id, :additional_resource_id, :prerequisite, :downloadable, :type, :can_discuss, :status)
    end
end
