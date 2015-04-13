class DocumentsController < ApplicationController
  def move
    @document = Document.find(params[:id_from])
    if @document.update_attribute(:folder_id, params[:id_to])
      respond_to do |format|
        format.html
        format.json {render :json => @document.to_json }
      end 
    else 
      respond_to do |format|
        format.html
        format.json {render :json => @document.errors.full_messages, :status => 422 }
      end 
    end

  end
end
