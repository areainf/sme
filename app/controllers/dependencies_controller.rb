class DependenciesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_dependency, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html, :json

  def index
    # @dependencies = Dependency.all
    respond_to do |format|
      format.html
      format.json {render json: get_data(view_context, params[:q], params[:id]) }
    end
    # respond_with(@dependencies)
  end

  def show
    respond_with(@dependency)
  end

  def new
    @dependency = Dependency.new
    if request.xhr?
      render '_remote_form', layout: false 
    else
      respond_with(@dependency)
    end
  end

  def edit
  end

  def create
    @dependency = current_user.dependencies.new(dependency_params)
    @dependency.save
    respond_with(@dependency)
  end

  def update
    @dependency.update(dependency_params)
    respond_with(@dependency)
  end

  def destroy
    @dependency.destroy
    respond_with(@dependency)
  end

  private
    def set_dependency
      @dependency = Dependency.find(params[:id])
    end

    def dependency_params
      params.require(:dependency).permit(:name, :description, :parent_id, :master_unit_id)
    end

    def get_data(view_context, query, id)
      if query.present?
        Dependency.where("name LIKE :search or
                         description LIKE :search",
                        search: "%#{query}%")
      elsif id.present?
        Dependency.find(id)
      else
        DependencyDatatable.new(view_context) 
      end
    end
end
