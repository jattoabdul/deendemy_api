class Api::V1::LessonsController < Api::V1::ApplicationController
  before_action :set_lesson, only: [:show, :update, :destroy]
  before_action :set_lesson_assessment, only: [:update_lesson_assessment]
  before_action :set_chapter, only: [:index, :create, :create_lesson_assessment, :update_lesson_assessment, :show, :update, :update_positions, :destroy]
  before_action :set_course, only: [:introduction, :introduction_index, :update_introduction]

  # GET courses/:course_id/chapters/:chapter_id/lessons
  def index
    @lessons = Lesson.includes([:chapter, :additional_resource, :content]).where(chapter_id: @chapter.id).order_by(position: :asc)

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

  # POST courses/:course_id/chapters/:chapter_id/lessons/assessments
  def create_lesson_assessment
    @assessment = Assessment.new(lesson_assessment_params.merge(chapter_id: @chapter.id))

    if @assessment.save
      render json: @assessment, status: :created
    else
      render json: ErrorSerializer.serialize(@assessment.errors), status: :unprocessable_entity
    end
  end

  # PUT courses/:course_id/chapters/:chapter_id/lessons/assessments/:assessment_id
  def update_lesson_assessment
    bad_request_error('cannot update lesson for this course chapters') && return unless chapter_course_owner_or_admin?
    if @assessment.update(lesson_assessment_update_params)
      render json: @assessment
    else
      render json: ErrorSerializer.serialize(@assessment.errors), status: :unprocessable_entity
    end
  end

  # POST courses/:course_id/lessons/introduction
  def introduction
    @lesson = Lesson.new(lesson_params)

    if @lesson.save
      @course.introduction = @lesson
      if @course.save
        render json: @lesson, status: :created
      else
        render json: ErrorSerializer.serialize(@course.errors), status: :unprocessable_entity
      end
    else
      render json: ErrorSerializer.serialize(@lesson.errors), status: :unprocessable_entity
    end
  end

  # TODO: PUT courses/:course_id/lessons/introduction
  def update_introduction
    @introduction = @course.introduction
    bad_request_error('cannot update introduction for this course') && return unless course_owner_or_admin?
    bad_request_error('cannot find an introduction for this course') if @introduction.blank?

    if @introduction.update(lesson_update_params)
      render json: @introduction
    else
      render json: ErrorSerializer.serialize(@introduction.errors), status: :unprocessable_entity
    end
  end

  # GET courses/:course_id/lessons/introduction
  def introduction_index
    # @lesson = Lesson.find(@course.introduction_id)
    @lesson = @course.introduction

    render json: @lesson
  end

  # PATCH/PUT courses/:course_id/chapters/:chapter_id/lessons/1
  def update
    bad_request_error('cannot update lesson for this course chapters') && return unless chapter_course_owner_or_admin?
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
    bad_request_error('cannot update position of lessons for this course chapter') && return unless chapter_course_owner_or_admin?

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
    bad_request_error('cannot delete chapter for this course') && return unless chapter_course_owner_or_admin?
    @lesson.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def set_lesson_assessment
      @assessment = Assessment.find(params[:assessment_id])
    end

    def set_chapter
      @chapter = Chapter.where(id: params[:chapter_id], course_id: params[:course_id]).first
    end

    def set_course
      @course = Course.includes([:introduction]).find(params[:course_id])
    end

    def course_owner_or_admin?
      (@course.tutor_id == current_api_v1_user.id) || (current_api_v1_user.roles.include?('admin') )
    end

    def chapter_course_owner_or_admin?
      (@chapter.course.tutor_id == current_api_v1_user.id) || (current_api_v1_user.roles.include?('admin') )
    end

    def lesson_params
      params.require(:lesson).permit(:title, :description, :content_id, :additional_resource_id, :prerequisite, :downloadable, :type, :can_discuss, :status, :position)
    end

    def lesson_update_params
      params.require(:lesson).permit(:title, :description, :content_id, :additional_resource_id, :prerequisite, :downloadable, :type, :can_discuss, :status)
    end

    def lesson_assessment_params
      params.require(:assessment).permit(:title, :description, :content_id, :additional_resource_id, :prerequisite, :downloadable, :type, :can_discuss, :status, :position, questions: [:type, :text, choices: [:value, :is_correct]])
    end

    def lesson_assessment_update_params
      params.require(:assessment).permit(:title, :description, :content_id, :additional_resource_id, :prerequisite, :downloadable, :type, :can_discuss, :status, questions: [:type, :text, choices: [:value, :is_correct]])
    end
end
