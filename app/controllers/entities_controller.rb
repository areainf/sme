class EntitiesController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy, :update_active]
  before_filter :authenticate_user!

  respond_to :html, :json

  load_and_authorize_resource

  def index
    @entities = get_data
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
    @entity = current_user.entities.new(entity_params)
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
      params.require(:entity).permit(:person_id, :dependency_id, :employment_id, :active)
  end

  def set_entity
    @entity = Entity.find params[:id]
  end

  def get_data
    query = params[:q]
    if current_user.is_dependency?
      if params[:senders].present?
        entities = current_user.permission.entities
      else
        entities = Entity.all #por ahora, deberia ser solo las enitdades del decanato
      end
    else
      entities = Entity.all
    end
    entities = entities.where("active = ?", params[:active].to_bool) if params[:active].present?
    entities = entities.joins("LEFT JOIN people as person ON entities.person_id = person.id
                  LEFT JOIN dependencies as dependency ON entities.dependency_id = dependency.id
                  LEFT JOIN employments as employment ON entities.employment_id = employment.id")
          .where("person.firstname LIKE :search or
                  person.lastname LIKE :search or
                  dependency.name LIKE :search or 
                  employment.name LIKE :search",search: "%#{query.sql_escape}%") unless query == '***'
    entities
  end
end
