class MasterUnitsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_master_unit, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json {render json: get_data(view_context, params[:q], params[:id]) }
    end
  end

  def show
    respond_with(@master_unit)
  end

  def new
    @master_unit = MasterUnit.new
    respond_with(@master_unit)
  end

  def edit
  end

  def create
    @master_unit = MasterUnit.new(master_unit_params)
    @master_unit.save
    respond_with(@master_unit)
  end

  def update
    @master_unit.update(master_unit_params)
    respond_with(@master_unit)
  end

  def destroy
    @master_unit.destroy
    respond_with(@master_unit)
  end

  private
    def set_master_unit
      @master_unit = MasterUnit.find(params[:id])
    end

    def master_unit_params
      params.require(:master_unit).permit(:name)
    end

    def get_data(view_context, query, id)
      if query.present?
        MasterUnit.where("name LIKE :search",
                        search: "%#{query}%")
      elsif id.present?
        MasterUnit.find(id)
      else
        MasterUnitDatatable.new(view_context) 
      end
    end
end
