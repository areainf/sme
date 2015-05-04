class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  layout :set_layout

  # def after_sign_in_path_for(resource)
  #     landing_page_path  if current_page?(action: "log_in")
  # end
  rescue_from CanCan::AccessDenied do |exception|
    if request.xhr?
      render json: {:status => :error, :errors => "No tienes permitido ejecutar #{exception.action}"}, :status => 403
    else
      flash[:error] = "Acceso Denegado!!!"
      redirect_to root_url
    end
  end
protected
  def set_layout
    if user_signed_in?
      "application"
    else
      "welcome"
    end
  end  
end
