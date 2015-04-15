class NotesController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    # @notes = Note.all
    respond_to do |format|
      format.html
      format.json {render json: get_data(view_context, params[:q], params[:id]) }
    end
  end

  def show
    respond_with(@note)
  end

  def new
    inp =  params[:direction].present? ? params[:direction] : 1
    @note = Note.new({:direction => inp})
    respond_with(@note)
  end

  def edit
  end

  def create
    params[:note][:recipients_attributes] = get_nested_entity_ids(params[:entities_to_ids])
    params[:note][:senders_attributes] = get_nested_entity_ids(params[:entities_from_ids])
    @note = Note.new(note_params)
    @note.save
    respond_with(@note)
  end

  def update
    params[:note][:recipients_attributes] = get_nested_and_delete_recipients(params[:entities_to_ids])
    params[:note][:senders_attributes] = get_nested_and_delete_senders(params[:entities_from_ids])
    @note.update(note_params)
    respond_with(@note)
  end

  def destroy
    @note.destroy
    respond_with(@note)
  end

  private
    def set_note
      @note = Note.find(params[:id])
    end

    def note_params
      params.require(:note).permit(:direction, :description, :observation, :reference_people, 
          :emission_date, :system_status, :folder_id, :recipient_text, :sender_text,
          :recipients_attributes => [:entity_id, :id, :_destroy], :senders_attributes => [:entity_id, :id, :_destroy])
    end

    def get_data(view_context, query, id)
      if query.present?
        Note.where("name LIKE :search or
                         name LIKE :search",
                        search: "%#{query}%")
      elsif id.present?
        Note.find(id)
      else
        NoteDatatable.new(view_context)
      end
    end

    def get_nested_entity_ids(entities_ids)
      entidades = []
      entities_ids.split(",").each do |e|
        entidades << {entity_id: e} if e.to_i > 0
      end
      entidades
    end

    def get_nested_and_delete_recipients(entities_ids)
      #en update el id que viene en los tokeninput es el id de reference no de entity
      delete_ids = @note.recipients.map(&:id)
      entidades = []
      entities_ids.split(",").each do |e|
        if delete_ids.include? e
          delete_ids.delete(e)
        else
          entidades << {entity_id: e}
        end
      end
      # delete delete_ids  from relations
      delete_ids.each do |id|
        recip = @note.recipients.find(id)
        entidades << {id: recip.id, _destroy: true}
        # recip.delete unless recip.blank?
      end
      entidades
    end
    def get_nested_and_delete_senders(entities_ids)
      #en update el id que viene en los tokeninput es el id de reference no de entity
      delete_ids = @note.senders(&:id)
      entidades = []
      entities_ids.split(",").each do |e|
        if delete_ids.include? e
          delete_ids.delete(e)
        else
          entidades << {entity_id: e}
        end
      end
      # delete delete_ids  from relations
      delete_ids.each do |id|
        s = @note.senders.find(id)
        entidades << {id: s.id, _destroy: true}
        #recip.delete unless recip.blank?
      end
      entidades
    end

end
