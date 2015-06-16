class AuthoritiesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :json

  def index
    @authorities = Authority.all#Entity.where("dependency_id is not NULL and employment_id is not NULL").group(:dependency_id, :employment_id)
    respond_to do |format|
      format.html
      format.json {render json: AuthorityDatatable.new(view_context) }
    end
  end

  def documents
    respond_to do |format|
        format.html{render :layout => false}
        format.json {render :json => AuthorityDocumentsDatatable.new(view_context)}
      end 
  end
end

