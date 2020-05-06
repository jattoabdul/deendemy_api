class Api::V1::CoursesController < Api::V1::ApplicationController
  before_action :set_course, only: [:show, :update, :approve, :destroy]

  # GET /courses
  def index
    @courses = Course.includes([:label, :introduction, :tutor]).all

    render json: @courses
  end

  # GET /courses/1
  def show
    render json: @course
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
  end

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
    @course.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:title, :subtitle, :label_id, :introduction_id, :type, :price, :status, :copy_text, :language, :level, seo: [:title, :description, tags: []], configs: [:name, :value], category_ids: [])
    end
end
