module ApplicationHelper
  DIR_OUTPUT = 0
  ROLE_ADMIN = "admin"
  ROLE_DEPENDENCY = "dependency"
  ROLE_RECEPTION = "reception"
  #use in main menu
  def current_tag(tag)
    'active' if controller_path == tag
  end
  def new_page?
    current_page?(action: 'new')
  end

  def edit_or_new_page?(object)
    current_page?(action: 'new') ||
    current_page?(action: 'edit', id: object.try(:id) || 0) ||
    (object.errors.present? if object.present?)
  end

  def show_page?(object)
    current_page?(action: 'show', id: object.try(:id) || 0)
  end
  def index_page?
    current_page?(action: 'index')
  end  

  # def to_bool(s)
  #   !!(s =~ /^(true|t|yes|y|1)$/i)
  # end
end
