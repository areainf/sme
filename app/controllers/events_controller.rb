class EventsController < ApplicationController
  before_filter :authenticate_user!
  # before_action :set_event, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  # def index
  #   @events = Event.all
  #   respond_with(@events)
  # end

  # def show
  #   respond_with(@event)
  # end

  def new
    @event = Event.new(event_params)
    if @event.date.blank?
      @event.date = Time.now
    end
    if request.xhr?
      render '_remote_form', :layout => false
    else
      respond_with(@event)
    end
  end

  # def edit
  # end

  def create
    @event = current_user.events.build(event_params)
    @event.save
    respond_with(@event)
  end

  # def update
  #   @event.update(event_params)
  #   respond_with(@event)
  # end

  # def destroy
  #   @event.destroy
  #   respond_with(@event)
  # end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:description, :date, :document_id)
    end
end
