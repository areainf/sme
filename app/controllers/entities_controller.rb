class EntitiesController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy, :update_active]
  before_filter :authenticate_user!

  respond_to :html, :json

  def index
    @entities = get_data(params[:q])
    respond_to do |format|
      format.json {render json:  @entities.to_json({:methods => [:name], :include => [:person, :dependency, :employment]}) }
    end
  end

  def new
    @entity = Entity.new
    @dependency = Dependency.new
    @employment = Employment.new
    @master_unit = MasterUnit.new
    @person = Person.new
    @person.entities.build
    if request.xhr?
      render '_remote_form', layout: false 
    else
      respond_with(@entity)
    end
  end

  def create
    @entity = Entity.new(entity_params)
    if @entity.save
      flash[:success] = t('flash.entity', message: t('flash.created'))
      respond_to do |format|
        format.html
        format.json { render :json =>  @entity, :include => [:person, :dependency, :employment] }
      end
    else 
      respond_to do |format|
        format.html
        format.json { render :json =>  @entity.errors.full_messages, status: :unprocessable_entity}
      end
    end
  end

  def update_active
    @entity.update_attribute(:active, params[:active])
    respond_to do |format|
        format.json { render :json =>  @entity, :include => [:person, :dependency, :employment] }
    end
  end

  def destroy
    flash[:success] = t('flash.entity', message: t('flash.deleted')) if @entity.destroy
    respond_to do |format|
        format.html
        format.json { render :json =>  @entity, :include => [:person, :dependency, :employment] }
    end
  end
private
  def entity_params
      params.require(:entity).permit(:person_id, :dependency_id, :employment_id)
  end

  def set_entity
    @entity = Entity.find params[:id]
  end

  def get_data(query)
    Entity.joins("LEFT JOIN people as person ON entities.person_id = person.id
                  LEFT JOIN dependencies as dependency ON entities.dependency_id = dependency.id
                  LEFT JOIN employments as employment ON entities.employment_id = employment.id")
          .where("person.firstname LIKE :search or
                  dependency.name LIKE :search or 
                  employment.name LIKE :search",search: "%#{query}%")
  end
end
