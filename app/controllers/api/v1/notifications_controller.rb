class Api::V1::NotificationsController < Api::V1::ApplicationController
  include ErrorSerializer
  before_action :set_notification, only: [:show, :mark_as_read]

  # GET /notifications
  def index
    filter = params[:filter] || nil # filters for read/unread

    @notifications = if filter == 'read'
      Notification.read.for_user(current_api_v1_user)
    elsif filter == 'unread'
      Notification.unread.for_user(current_api_v1_user)
    else
      Notification.for_user(current_api_v1_user)
    end

    render json: @notifications
  end

  # GET /notifications/1
  def show
    render json: @notification
  end

  # POST/PATCH/PUT /notifications/1/read
  def mark_as_read
    if @notification.update(read_at: Time.now)
      render json: @notification
    else
      render json: ErrorSerializer.serialize(@notification.errors), status: :unprocessable_entity
    end
  end

  # POST /notifications/read
  # POST /notifications/read/all
  def mark_all_as_read
    @notifications = Notification.unread.for_user(current_api_v1_user)
    @notifications.update_all(read_at: Time.now) unless @notifications.blank?
    @notifications = Notification.where(recipient_id: current_api_v1_user.id)
  
    render json: @notifications
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.for_user(current_api_v1_user).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def notification_params
      params.require(:notification).permit(:recipient_id, :actor_id, :read_at, :action)
    end
end
