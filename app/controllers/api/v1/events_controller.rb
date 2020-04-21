class Api::V1::EventsController < Api::V1::ApplicationController
  before_action :set_event, only: [:show]

  # GET /events
  def index
    @events = Event.all

    render json: @events
  end

  # GET /events/1
  def show
    render json: @event
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
