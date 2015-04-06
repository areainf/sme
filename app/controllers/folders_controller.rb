class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @folders = Folder.all
    respond_with(@folders)
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
    @folder.save
    respond_with(@folder)
  end

  def update
    @folder.update(folder_params)
    respond_with(@folder)
  end

  def destroy
    @folder.destroy
    respond_with(@folder)
  end

  private
    def set_folder
      @folder = Folder.find(params[:id])
    end

    def folder_params
      params.require(:folder).permit(:name, :parent_id, :description)
    end
end
