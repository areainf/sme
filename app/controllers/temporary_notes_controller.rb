class TemporaryNotesController < InheritedResources::Base
  before_filter :authenticate_user!

  before_action :set_temporary_note, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  load_and_authorize_resource

  # View Own Temporary Note
  def index
    # @temporary_notes = current_user.documents_created.where(type: TemporaryNote.name)
    respond_to do |format|
      format.html
      format.json {render json: get_data(view_context, params[:q], params[:id]) }
    end
  end
  
  def new
    @temporary_note = TemporaryNote.new({:direction => TemporaryNote::DIR_IN,:emission_date => Time.now})
    respond_with(@temporary_note)
  end

  def create
    params[:temporary_note][:recipients_attributes] = get_nested_entity_ids(params[:entities_to_ids])
    params[:temporary_note][:senders_attributes] = get_nested_entity_ids(params[:entities_from_ids])
    params[:temporary_note][:create_user_id] = current_user.id
    @temporary_note = TemporaryNote.new(temporary_note_params)
    if @temporary_note.save
      # to handle multiple images upload on create
      if params[:attachments]
        params[:attachments].each{|file|
          @temporary_note.attachments.create({:filedoc => file})
        }
      end
      flash[:success] = t('flash.temporary_note', message: t('flash.created'))
    else 
      flash[:alert] = @temporary_note.errors.flush_messages
    end
    respond_with(@temporary_note)
  end

  def update
    params[:temporary_note][:recipients_attributes] = get_nested_and_delete_recipients(params[:entities_to_ids])
    params[:temporary_note][:senders_attributes] = get_nested_and_delete_senders(params[:entities_from_ids])
    if @temporary_note.update(temporary_note_params)
      if params[:attachments]
        params[:attachments].each{|file|
          @temporary_note.attachments.create({:filedoc => file})
        }
      end
      if params[:attachments_destroy]
        params[:attachments_destroy].each do |attach|
          attachment = Attachment.find(attach)
          attachment.destroy
        end
      end
      flash[:success] = t('flash.temporary_note', message: t('flash.updated'))
    else 
      flash[:alert] = @temporary_note.errors.flush_messages
    end
    respond_with(@temporary_note)
  end

  private
    def set_temporary_note
      @temporary_note = TemporaryNote.find(params[:id])
    end

    def temporary_note_params
      params.require(:temporary_note).permit(:description, :observation, :reference_people, 
          :emission_date, :system_status, :folder_id, :recipient_text, :sender_text, :create_user_id,
          :recipients_attributes => [:entity_id, :id, :_destroy], :senders_attributes => [:entity_id, :id, :_destroy])
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
      delete_ids = @temporary_note.recipients.map(&:id)
      entidades = []
      entities_ids.split(",").each do |e|
        if delete_ids.include? e
          delete_ids.delete(e)
        else
          entidades << {entity_id: e}  if e.to_i > 0
        end
      end
      # delete delete_ids  from relations
      delete_ids.each do |id|
        recip = @temporary_note.recipients.find(id)
        entidades << {id: recip.id, _destroy: true}
        # recip.delete unless recip.blank?
      end
      entidades
    end
    def get_nested_and_delete_senders(entities_ids)
      #en update el id que viene en los tokeninput es el id de reference no de entity
      delete_ids = @temporary_note.senders(&:id)
      entidades = []
      entities_ids.split(",").each do |e|
        if delete_ids.include? e
          delete_ids.delete(e)
        else
          entidades << {entity_id: e} if e.to_i > 0
        end
      end
      # delete delete_ids  from relations
      delete_ids.each do |id|
        s = @temporary_note.senders.find(id)
        entidades << {id: s.id, _destroy: true}
        #recip.delete unless recip.blank?
      end
      entidades
    end

    def get_data(view_context, query, id)
      if query.present?
        TemporaryNote.where("name LIKE :search or
                         name LIKE :search",
                        search: "%#{query}%")
      elsif id.present?
        TemporaryNote.find(id)
      else
        TemporaryNoteDatatable.new(view_context, current_user)
      end
    end

end

