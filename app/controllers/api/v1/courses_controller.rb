class Api::V1::CoursesController < Api::V1::ApplicationController
  before_action :set_course, only: %i(show update approve destroy fetch_course_reviews)

  # GET /courses
  # GET /courses?filters=
  def index
    # users can filter by rating, enrollments,
    @courses = Course.includes(%i(label introduction tutor)).approved

    render json: @courses
  end

  # GET /courses/all
  # GET /courses/all?filters=
  def fetch_all
    # admins can filter by rating, enrollments, etc
    @courses = Course.includes(%i(label introduction tutor)).all

    render json: @courses
  end

  # GET /courses/tutor
  # GET /courses/tutor?filters=
  def fetch_tutor_courses
    # tutor can filter by rating, enrollments, etc
    @courses = Course.includes(%i(label introduction tutor)).where(tutor_id: current_api_v1_user.id)

    render json: @courses
  end

  # GET /courses/1
  def show
    render json: @course, serializer: CourseDetailSerializer
  end

  # POST /courses
  def create
    @course = Course.new(course_params.merge(tutor_id: current_api_v1_user.id))

    if @course.save
      render json: @course, status: :created
    else
      render json: ErrorSerializer.serialize(@course.errors), status: :unprocessable_entity
    end
  end

  # POST /courses/1/approve
  def approve
    # approve course
    params.permit(:status)
    unless %w(approved rejected).include?(params[:status])
      bad_request_error('Invalid Course Status, Allowed values: [approved, rejected]')
      return
    end

    if @course.update(status: params[:status])
      render json: @course
    else
      render json: ErrorSerializer.serialize(@course.errors), status: :unprocessable_entity
    end
  end

  # GET /courses/1/reviews
  # GET /courses/1/ratings
  def fetch_course_reviews
    render json: @course.ratings.is_active
  end

  # TODO: Implement routes
  # DELETE /courses/1/reviews/1
  # DELETE /courses/1/ratings/1
  # def delete_course_reviews
  #   review owner only route
  #   return json: @rating.update(is_deleted: true)
  # end

  # POST /courses/1/reviews/1/suspend?action=published
  # POST /courses/1/ratings/1/status?action=suspended
  # def toggle_course_reviews_status
  #   admin only route
  #   return json: @rating.update(status: params[:action])
  # end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
      render json: @course
    else
      render json: ErrorSerializer.serialize(@course.errors), status: :unprocessable_entity
    end
  end

  # DELETE /courses/1
  def destroy
    # TODO: only course owner or admin can delete a course (soft delete)
    # (note: cannot delete already enrolled in course)
    @course.destroy
  end

  private
    def set_course
      @course = Course.includes(:introduction, :chapters, :tutor, :label).find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :subtitle, :label_id, :introduction_id, :type, :price, :status, :copy_text, :language, :level, seo: [:title, :description, tags: []], configs: %i(name value), category_ids: [])
    end
end
