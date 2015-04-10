class FoldersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    if params[:id].present?
      result_json = folder_child(params[:id])
    else
      result_json = folder_root
    end
    respond_to do |format|
      format.html
      format.json {render :json => result_json }
    end    
  end

  def show
    respond_with(@folder)
  end

  def new
    @folder = Folder.new
    respond_with(@folder)
  end

  def edit
  end

  def create
    @folder = Folder.new(folder_params)
    if @folder.save
      # respond_to do |format|
      #   format.html
      #   format.json {render :json => @folder.to_json }
      # end 
      render :json => @folder.to_json
    else 
      # respond_to do |format|
      #   format.html
      #   format.json {render :json => @folder.errors.full_messages, :status => 422 }
      # end 
      render :json => @folder.errors.full_messages, :status => 422 
    end
  end

  def update
    @folder.update(folder_params)
    respond_with(@folder)
  end

  def destroy
    @folder.destroy
    respond_with(@folder)
  end

  def move_folder
    @folder = Folder.find(params[:id_from])
    if @folder.update_attribute(:parent_id, params[:id_to])
      respond_to do |format|
        format.html
        format.json {render :json => @folder.to_json }
      end 
    else 
      respond_to do |format|
        format.html
        format.json {render :json => @folder.errors.full_messages, :status => 422 }
      end 
    end

  end
  private
    def set_folder
      @folder = Folder.find(params[:id])
    end

    def folder_params
      params.require(:folder).permit(:name, :parent_id, :description)
    end
    #No esta en uso
    #Este metodo se deberia usar si se quiere listar todos las carpetas y documentos
    # sin lazy load
    # def folder_structure(collection, documents, result, init=false)
    #   current = {}
    #   if !collection.empty?
    #     collection.each do |f|
    #       current = {key: f.id, title: f.name, folder: true}
    #       current[:children] = folder_structure(f.childs, f.documents.map{|x| x.id}, result) unless f.childs.empty?
    #       #return current
    #     end
    #   end
    #   if !init
    #     documents.each do |d|
    #       doc = Document.find(d)
    #       current[:children] = [] if current[:children].nil?
    #       current[:children] << {title: doc.description, id: d }
    #     end
    #   end
    #   result << current
    #   if init
    #     documents.each do |d|
    #       doc = Document.find(d)
    #       current[:children] = [] if current[:children].nil?

    #       if init
    #         result << {title: doc.description, id: d }
    #       else
    #         current[:children] << {title: doc.description, id: d }
    #       end
    #     end
    #   end
    #   return result
    # end

    def folder_root
      root = {title: "/", key: "", folder: true, children: []}
      Folder.root.each do |f|
        root[:children] << {title: f.name, key: f.id, folder: true, lazy: true}
      end
      Document.where("folder_id is NULL").each do |d|
        root[:children]  << {title: d.description, key: d.id}
      end
      [root]
    end
    def folder_child(id)
      f = Folder.find(params[:id])
      folders = f.childs
      documents = f.documents
      result_json = []
      folders.each do |f|
        result_json << {title: f.name, key: f.id, folder: true, lazy: true}
      end
      documents.each do |d|
        result_json << {title: d.description, key: d.id}
      end
      result_json
    end
end
