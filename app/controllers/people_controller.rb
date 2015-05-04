class PeopleController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html, :json


  def index
    respond_to do |format|
      format.html
      format.json { render json: get_data(view_context, params[:q], params[:id]) }
    end
  end

  def show
    respond_with(@person)
  end

  def new
    @person = Person.new
    if request.xhr?
      @person.entities.build
      render '_remote_form', layout: false 
    else
      respond_with(@person)
    end
  end

  def edit
  end

  def create
    @person = Person.new(person_params)
    @person.save
    respond_with(@person)
  end

  def update
    @person.update(person_params)
    respond_with(@person)
  end

  def destroy
    @person.destroy
    respond_with(@person)
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:firstname, :lastname, :entities_attributes => [:dependency_id, :employment_id])
    end

    def get_data(view_context, query, id)
      if query.present?
        Person.where("firstname LIKE :search or
                         lastname LIKE :search",
                        search: "%#{query}%").to_json(:methods => :fullname)
      elsif id.present?
        Person.find(id).to_json
      else
        PersonDatatable.new(view_context).to_json
      end      
    end
end
