class DocumentsController < ApplicationController
  before_filter :authenticate_user!
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
    @document = Document.find(params[:id])
    if request.xhr?
      render :layout => false
    else
      respond_with(@document)
    end
  end

  def move
    @document = Document.find(params[:id_from])
    if @document.update_attribute(:folder_id, params[:id_to])
      respond_to do |format|
        format.html
        format.json {render :json => @document.to_json }
      end 
    else 
      respond_to do |format|
        format.html
        format.json {render :json => @document.errors.full_messages, :status => 422 }
      end 
    end
  end

  def in_folder
    if params[:folder_id].blank?
      @documents = Document.where("folder_id is NULL or folder_id = ''")
    else
      @documents = Folder.find(params[:folder_id]).documents
    end
    # @notes = Note.all
    if request.xhr?
      render :layout => false
    else
      respond_with(@documents)
    end
  end

private
  def get_data(view_context, query, id)
    if id.present?
      Document.find(id)
    else
      DocumentDatatable.new(view_context)
    end
  end
end
