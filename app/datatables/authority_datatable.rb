class AuthorityDatatable
  include Rails.application.routes.url_helpers

  delegate :simple_format, :params, :raw, :link_to,  to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Authority.all.length,
      iTotalDisplayRecords: authorities.total_entries,
      aaData: data
    }
  end

private

  def data
    authorities.map do |entity|
      [
        entity.dependency.id,
        entity.employment.id,
        entity.dependency.name,
        entity.employment.name,
        #build_link(entity)
      ]
    end
  end

  def authorities
    fetch_authorities
  end

  def fetch_authorities
    authorities = Authority.all.order("#{sort_column}")
    authorities = authorities.page(page).per_page(per_page)
    if params[:search].present?
      authorities = authorities.joins("LEFT JOIN people on `entities`.person_id = people.id
                                       LEFT JOIN employments on `entities`.employment_id = employments.id
                                      LEFT JOIN dependencies on `entities`.dependency_id = dependencies.id")
      authorities = authorities.where("dependencies.name like :search or
                                  people.firstname like :search or
                                  people.lastname like :search or
                                  employments.name like :search ",
                                  search: "%#{params[:search][:value]}%")
    end
    authorities
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w(dependencies.name employment.name)
    sort_by = []
    params[:order].each_value do |item|
      Rails.logger.info(ap item)
      sort_by << "#{columns[item['column'].to_i]} #{item['dir']}"
    end if params[:order].present?
    sort_by.join(', ')  
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def build_link(dep)
    # icon_edit = '<span class="glyphicon glyphicon-edit"></span>'
    # icon_show = '<span class="glyphicon glyphicon-info-sign"></span>'
    # link = link_to(raw(icon_show), dep)
    # link += link_to(raw(icon_edit), edit_dependency_path(dep))
    # raw('<div class="datatable-actions">'+link+'</div>')
  end  

end