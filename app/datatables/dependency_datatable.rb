class DependencyDatatable
  include Rails.application.routes.url_helpers

  delegate :simple_format, :params, :raw, :link_to,  to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Dependency.count,
      iTotalDisplayRecords: dependencies.total_entries,
      aaData: data
    }
  end

private

  def data
    dependencies.map do |dependency|
      [
        link_to(dependency.name, dependency),
        link_to(dependency.description, dependency),
        (dependency.parent.try(:name)),
        (dependency.master_unit.try(:name)),
        build_link(dependency)

      ]
    end
  end

  def dependencies
    @dependencies ||= fetch_dependencies
  end

  def fetch_dependencies
    dependencies = Dependency.includes(:master_unit, :parent).references(:master_unit, :parent).order("#{sort_column}")
    dependencies = dependencies.page(page).per_page(per_page)
    if params[:search].present?
      dependencies = dependencies.where("dependencies.name like :search or
                                  master_units.name like :search or
                                  parents_dependencies.name like :search ",
                                  search: "%#{params[:search][:value]}%")
    end
    dependencies
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w(dependencies.name dependencies.description parents_dependencies.name master_units.name)
    sort_by = []
    params[:order].each_value do |item|
      Rails.logger.info(ap item)
      sort_by << "#{columns[item['column'].to_i]} #{item['dir']}"
    end
    sort_by.join(', ')  
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def build_link(dep)
    icon_edit = '<span class="glyphicon glyphicon-edit"></span>'
    icon_show = '<span class="glyphicon glyphicon-info-sign"></span>'
    link = link_to(raw(icon_show), dep)
    link += link_to(raw(icon_edit), edit_dependency_path(dep))
    raw('<div class="datatable-actions">'+link+'</div>')
  end  

end
# class DependencyDatatable < AjaxDatatablesRails::Base
#   def_delegator :@view, :link_to
#   def_delegator :@view, :raw  # uncomment the appropriate paginator module,
#   # depending on gems available in your project.
#   # include AjaxDatatablesRails::Extensions::Kaminari
#   include AjaxDatatablesRails::Extensions::WillPaginate
#   # include AjaxDatatablesRails::Extensions::SimplePaginator
#   include Rails.application.routes.url_helpers

#   def sortable_columns
#     # list columns inside the Array in string dot notation.
#     # Example: 'users.email'
#     @sortable_columns ||= ['dependencies.name', 'dependencies.description', 'parents_dependencies.name', 'master_units.name']
#   end

#   def searchable_columns
#     # list columns inside the Array in string dot notation.
#     # Example: 'users.email'
#     @searchable_columns ||= ['dependencies.name', 'dependencies.description', 'master_units.name']
#   end

#   private

#   def data
#     records.map do |record|
#       [
#         # comma separated list of the values for each cell of a table row
#         # example: record.attribute,
#         record.name,
#         record.description,
#         record.parent.try(:name) || "",
#         record.master_unit.try(:name) || "",
#         build_link(record)
#       ]
#     end
#   end

#   def get_raw_records
#     Dependency.includes(:parent, :master_unit).references(:master_unit, :parent).distinct
#       # Dependency.all.joins(
#       #           "LEFT JOIN dependencies as dependency on dependencies.dependency_id=dependency.id
#       #            LEFT JOIN master_units as master_unit on dependencies.master_unit_id=master_unit.id")
#   end

#   # ==== Insert 'presenter'-like methods below if necessary
#   def build_link(dep)
#     icon_edit = '<span class="glyphicon glyphicon-edit"></span>'
#     icon_show = '<span class="glyphicon glyphicon-info-sign"></span>'
#     link = link_to(raw(icon_show), dep)
#     link += link_to(raw(icon_edit), edit_dependency_path(dep))
#     raw('<div class="datatable-actions">'+link+'</div>')
#   end  
# end
