class NotesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_note, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  load_and_authorize_resource

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
    @note = Note.new({:direction => inp,:emission_date => Time.now})
    respond_with(@note)
  end

  def edit
  end

  def create
    params[:note][:recipients_attributes] = get_nested_entity_ids(params[:entities_to_ids])
    params[:note][:senders_attributes] = get_nested_entity_ids(params[:entities_from_ids])
    params[:note][:create_user_id] = current_user.id if params[:note][:create_user_id].blank?
    params[:note][:entry_user_id] = current_user.id
    @note = Note.new(note_params)
    if @note.save
      if params[:attachments]
        params[:attachments].each{|file|
          @note.attachments.create({:filedoc => file})
        }
      end
      unless @note.temporary.blank?
        @note.temporary.attachments.each do |attach|
          @note.attachments.create({:filedoc =>  File.open(attach.filedoc.path)})
        end
      end
      flash[:success] = t('flash.note', message: t('flash.created'))
    else
      flash[:alert] = @note.errors.flush_messages
    end
    respond_with(@note)

  end

  def update
    params[:note][:recipients_attributes] = get_nested_and_delete_recipients(params[:entities_to_ids])
    params[:note][:senders_attributes] = get_nested_and_delete_senders(params[:entities_from_ids])
    if @note.update(note_params)
      if params[:attachments]
        params[:attachments].each{|file|
          @note.attachments.create({:filedoc => file})
        }
      end
      if params[:attachments_destroy]
        params[:attachments_destroy].each do |attach|
          attachment = Attachment.find(attach)
          attachment.destroy
        end
      end
      flash[:success] = t('flash.note', message: t('flash.updated'))
    else
      flash[:alert] = @note.errors.flush_messages
    end
    respond_with(@note)
  end

  def destroy
    @note.destroy
    respond_with(@note)
  end

  def enter
    @temporary = TemporaryNote.find(params[:temporary_id])
    @note = Note.new(@temporary.attributes.except('id', 'created_at', 'updated_at', 'entry_at', 'type','recipients', 'senders'))
    @note.direction = Document::DIR_IN
    render "new"
  end
  private
    def set_note
      @note = Note.find(params[:id])
    end

    def note_params
      params.require(:note).permit(:direction, :description, :observation, :reference_people, :entry_user_id,
          :emission_date, :system_status, :folder_id, :recipient_text, :sender_text, :create_user_id, :temporary_id,
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
          entidades << {entity_id: e}  if e.to_i > 0
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
          entidades << {entity_id: e} if e.to_i > 0
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
