class EmploymentsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_employment, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  load_and_authorize_resource

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
    @employment = current_user.employments.create(employment_params)
    if @employment.save
      flash[:success] = t('flash.entity', message: t('flash.created'))
      respond_with(@employment)
    else 
      respond_to do |format|
        format.html{render  'new'}
        format.json { render :json =>  @employment.errors.full_messages, status: :unprocessable_entity}
      end
    end
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
