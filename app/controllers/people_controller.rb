class PeopleController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @people = Person.all
    respond_to do |format|
      format.html
      format.json { render json: PersonDatatable.new(view_context) }
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
end
