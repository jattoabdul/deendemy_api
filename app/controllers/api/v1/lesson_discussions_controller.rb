class Api::V1::LessonDiscussionsController < Api::V1::ApplicationController
  before_action :set_lesson_discussion, only: [:show, :update, :destroy]
  before_action :set_lesson, only: [:index, :show, :create, :update, :destroy]
  before_action :set_course, only: [:index, :show, :create, :update, :destroy]

  # GET courses/:course_id/lessons/:lesson_id/discussions
  def index
    @lesson_discussions = LessonDiscussion.includes([:sender, :children, :lesson, :course]).where(course_id: @course.id, lesson_id: @lesson.id, parent_id: nil)
    # .order_by(created_at: :asc)
    # TODO: paginate and load first 10 discussions only

    render json: @lesson_discussions
  end

  # GET /lesson_discussions
  def all_discussions
    @lesson_discussions = LessonDiscussion.all

    render json: @lesson_discussions
  end

  # GET courses/:course_id/lessons/:lesson_id/discussions/1
  def show
    render json: @lesson_discussion
  end

  # POST courses/:course_id/lessons/:lesson_id/discussions
  def create
    @lesson_discussion = LessonDiscussion.new(lesson_discussion_params.merge(course_id: @course.id, lesson_id: @lesson.id))

    if lesson_discussion_params[:parent_id].present?
      @root_discussion = LessonDiscussion.find(lesson_discussion_params[:parent_id])
      bad_request_error('cannot reply to a lesson discussion reply') && return unless @root_discussion.parent_id.nil?
      @lesson_discussion.parent_id = @root_discussion._id
    end

    if @lesson_discussion.save!
      render json: @lesson_discussion, status: :created
    else
      render json: @lesson_discussion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT courses/:course_id/lessons/:lesson_id/discussions/1
  def update
    # bad_request_error('cannot update lesson for this course chapters') && return unless disucssion_owner_or_admin?
    if @lesson_discussion.update(lesson_discussion_params)
      render json: @lesson_discussion
    else
      render json: @lesson_discussion.errors, status: :unprocessable_entity
    end
  end

  # DELETE courses/:course_id/lessons/:lesson_id/discussions/1
  def destroy
    @lesson_discussion.destroy
  end

  private
    def set_lesson_discussion
      @lesson_discussion = LessonDiscussion.find(params[:id])
    end

    def set_lesson
      @lesson = Lesson.find(params[:lesson_id])
    end

    def set_course
      @course = Course.includes([:introduction]).find(params[:course_id])
    end

    def lesson_discussion_params
      params.require(:lesson_discussion).permit(:body, :sender_id, :parent_id)
    end
end
