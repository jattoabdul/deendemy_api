class Api::V1::EnrollmentsController < Api::V1::ApplicationController
  before_action :set_enrollment, only: %i(show toggle_enrollment_status start_enrollment_lesson complete_enrollment_lesson reset_enrollment_progress fetch_enrollment_lesson_progresses rate_course)
  before_action :set_learner, only: [:fetch_learner_enrollments]
  before_action :set_course, only: %i(fetch_course_enrollments start_enrollment_lesson complete_enrollment_lesson rate_course)
  before_action :set_lesson, only: %i(start_enrollment_lesson complete_enrollment_lesson)

  # GET /enrollments
  def index
    bad_request_error('Unauthorized Access to List of Enrollments') && return unless current_api_v1_user.roles.include?('admin')
    @enrollments = Enrollment.all
    # TODO: Add pagination, fetch only first 20 by default
    render json: @enrollments
  end

  # POST /enrollments
  def create
    bad_request_error('Unauthorized Access to Creating Enrollment') && return unless current_api_v1_user.roles.include?('admin')
    @enrollment = Enrollment.new(enrollment_params)

    if @enrollment.save
      render json: @enrollment, status: :created
    else
      render json: ErrorSerializer.serialize(@enrollment.errors), status: :unprocessable_entity
    end
  end

  # GET /enrollments/learners/:learner_id
  def fetch_learner_enrollments
    bad_request_error('Unauthorized Access to Learner Enrollments') && return unless enrollment_learner_or_admin?
    @enrollments = Enrollment.where(learner_id: @learner.id)
    # TODO: Add pagination, fetch only first 20 by default
    render json: @enrollments
  end

  # GET /courses/:id/enrollments
  # GET /enrollments/courses/:course_id
  def fetch_course_enrollments
    bad_request_error('Unauthorized Access to Course Enrollments') && return unless enrollment_course_tutor_or_admin?
    @enrollments = Enrollment.where(course_id: @course.id)
    # TODO: Add pagination, fetch only first 20 by default
    render json: @enrollments
  end

  # GET /enrollments/1
  def show
    bad_request_error('Unauthorized Access to Enrollment') && return unless enrollment_owner_course_tutor_or_admin?
    render json: @enrollment
  end

  # PATCH/PUT /enrollments/1/status
  def toggle_enrollment_status
    bad_request_error('Unauthorized Access to Enrollment') && return unless enrollment_owner_or_admin?
    status = params.require(:enrollment).permit(:status)[:status]
    if @enrollment.update(status: status)
      render json: @enrollment
    else
      render json: ErrorSerializer.serialize(@enrollment.errors), status: :unprocessable_entity
    end
  end

  # POST /enrollments/:id/courses/:course_id/lessons/:lesson_id/start
  def start_enrollment_lesson
    bad_request_error('Course and Enrollment do not match') && return unless @enrollment.course_id == @course.id
    bad_request_error('Lesson does not belong to Course') && return unless @course.id == @lesson.chapter.course_id
    bad_request_error('Unauthorized Access to Start Enrollment Lesson') && return unless enrollment_owner_or_admin?
    
    progress_params = {
        course_id: params[:course_id],
        lesson_id: params[:lesson_id],
        enrollment_id: params[:id],
        status: 'started'
    }
    # Ensure No progress with this params already exist
    @progress = Progress.where(progress_params.except(:status)).first
    bad_request_error("Invalid request: Lesson already #{@progress.status || 'started'}") && return if @progress

    @progress = Progress.new(progress_params)

    if @progress.save
      render json: @progress, status: :created
    else
      render json: ErrorSerializer.serialize(@progress.errors), status: :unprocessable_entity
    end
  end

  # POST /enrollments/:id/courses/:course_id/lessons/:lesson_id/complete
  def complete_enrollment_lesson
    bad_request_error('Course and Enrollment do not match') && return unless @enrollment.course_id == @course.id
    bad_request_error('Lesson does not belong to Course') && return unless @course.id == @lesson.chapter.course_id
    bad_request_error('Unauthorized Access to Complete Enrollment Lesson') && return unless enrollment_owner_or_admin?

    progress_params = {
        course_id: params[:course_id],
        lesson_id: params[:lesson_id],
        enrollment_id: params[:id]
    }

    @progress = Progress.where(progress_params).first

    bad_request_error('Invalid request: Lesson has not been commenced') && return unless @progress.present?
    bad_request_error('Invalid request: Lesson already completed') && return if @progress.status == 'completed'

    if @progress.update(status: 'completed')
      @enrollment.update(progress: @enrollment.progress)
      render json: @progress
    else
      render json: ErrorSerializer.serialize(@progress.errors), status: :unprocessable_entity
    end
  end

  # POST /enrollments/:id/progress/reset
  def reset_enrollment_progress
    bad_request_error('Unauthorized Access to Reset Enrollment Progress') && return unless enrollment_owner_or_admin?

    @progress = Progress.where(enrollment_id: @enrollment.id)
    @progress.destroy_all
    @enrollment.update(status: 'started', progress: 0)
    render json: {'message': 'enrollment progress reset successfully'}
  end

  # GET /enrollments/:id/progress
  def fetch_enrollment_lesson_progresses
    bad_request_error('Unauthorized Access to View Enrollment Progress') && return unless enrollment_owner_or_admin?

    @progresses = Progress.where(enrollment_id: @enrollment.id)
    render json: @progresses
  end

  # POST /enrollments/:id/courses/:course_id/rate
  def rate_course
    params.require(:rating)
    params.permit(:rating, :review)
    bad_request_error('Course and Enrollment do not match') && return unless @enrollment.course_id == @course.id
    bad_request_error('Unauthorized Access to Rate a Course') && return unless @enrollment.learner_id == current_api_v1_user.id

    review = params[:review] unless params[:review].blank?

    @rating = Rating.where(user_id: current_api_v1_user.id, course_id: @course.id).first_or_initialize(rating: params[:rating], review: review)
    unless @rating.new_record?
      @rating.rating = params[:rating]
      @rating.review = review
    end

    if @rating.save
      render json: @rating, status: :accepted
    else
      render json: ErrorSerializer.serialize(@rating.errors), status: :unprocessable_entity
    end
  end

  private
  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def set_learner
    @learner = User.find(params[:learner_id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_lesson
    @lesson = Lesson.includes([:chapter]).find(params[:lesson_id])
  end

  def enrollment_params
    params.require(:enrollment).permit( :payment_id, :course_id, :learner_id, :cancel_reason, :is_deleted)
  end

  def enrollment_owner_or_admin?
    (@enrollment.learner_id == current_api_v1_user.id) || current_api_v1_user.roles.include?('admin')
  end

  def enrollment_learner_or_admin?
  (@learner.id == current_api_v1_user.id) || current_api_v1_user.roles.include?('admin')
  end

  def enrollment_course_tutor_or_admin?
    # check to ensure that it is an admin or the tutor of the course
    (@course.tutor_id == current_api_v1_user.id) || current_api_v1_user.roles.include?('admin')
  end

  def enrollment_owner_course_tutor_or_admin?
    # check to ensure that it is an admin, the tutor of the course, or a learner’s enrollment
    (@enrollment.learner_id == current_api_v1_user.id) || (@enrollment.course.tutor_id == current_api_v1_user.id) || current_api_v1_user.roles.include?('admin')
  end
end
