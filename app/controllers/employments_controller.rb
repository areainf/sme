class EmploymentsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_employment, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    respond_to do |format|
      format.html
      format.json {render json: get_data(view_context, params[:q], params[:id]) }
    end
  end

  def show
    respond_with(@employment)
  end

  def new
    @employment = Employment.new
    if request.xhr?
      render '_remote_form', layout: false 
    else
      respond_with(@employment )
    end
  end

  def edit
  end

  def create
    @employment = Employment.new(employment_params)
    @employment.save
    respond_with(@employment)
  end

  def update
    @employment.update(employment_params)
    respond_with(@employment)
  end

  def destroy
    @employment.destroy
    respond_with(@employment)
  end

  private
    def set_employment
      @employment = Employment.find(params[:id])
    end

    def employment_params
      params.require(:employment).permit(:name)
    end
    def get_data(view_context, query, id)
      if query.present?
        Employment.where("name LIKE :search or
                         name LIKE :search",
                        search: "%#{query}%")
      elsif id.present?
        Employment.find(id)
      else
        EmploymentDatatable.new(view_context)
      end
    end
end
