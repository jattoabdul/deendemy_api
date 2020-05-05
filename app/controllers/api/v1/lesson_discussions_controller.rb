class Api::V1::LessonDiscussionsController < Api::V1::ApplicationController
  before_action :set_lesson_discussion, only: [:show, :update, :destroy]
  before_action :set_lesson, only: [:index, :show, :create, :update, :destroy]
  before_action :set_course, only: [:index, :show, :create, :update, :destroy]

  # GET courses/:course_id/lessons/:lesson_id/discussions
  def index
    # TODO: User can't fetch discussions in a course if they are not enrolled in the course || an admin || course creator
    @lesson_discussions = LessonDiscussion.includes([:sender, :children, :lesson, :course]).where(course_id: @course.id, lesson_id: @lesson.id, parent_id: nil)
    # .order_by(created_at: :asc)
    # TODO: paginate and load first 10 discussions only

    render json: @lesson_discussions
  end

  # GET courses/:course_id/lessons/:lesson_id/discussions/1
  def show
    # TODO: User can't view discussion in a course if they are not enrolled in the course || an admin || course creator
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
    bad_request_error('cannot update this discussion for this lesson') && return unless discussion_owner_or_admin?

    if @lesson_discussion.update(lesson_discussion_params)
      render json: @lesson_discussion
    else
      render json: @lesson_discussion.errors, status: :unprocessable_entity
    end
  end

  # DELETE courses/:course_id/lessons/:lesson_id/discussions/1
  def destroy
    bad_request_error('cannot delete this discussion for this lesson') && return unless discussion_owner_or_admin?
  
    if @lesson_discussion.parent_id.blank? && @lesson_discussion.children.present?
      @lesson_discussion.update(is_deleted: true)
    elsif @lesson_discussion.parent_id.blank? && @lesson_discussion.children.blank?
      @lesson_discussion.destroy
    else
      parent_lesson_discussion = @lesson_discussion.parent
      parent_lesson_discussion_children = parent_lesson_discussion.children
      replies = parent_lesson_discussion_children.many?
      @lesson_discussion.destroy
      parent_lesson_discussion.destroy if !replies  && parent_lesson_discussion.is_deleted
    end
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

    def discussion_owner_or_admin?
      (@lesson_discussion.sender_id == current_api_v1_user.id) || (current_api_v1_user.roles.include?('admin') )
    end

    def lesson_discussion_params
      params.require(:lesson_discussion).permit(:body, :sender_id, :parent_id)
    end
end
