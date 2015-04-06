class EmploymentDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :raw
  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  # include AjaxDatatablesRails::Extensions::Kaminari
  include AjaxDatatablesRails::Extensions::WillPaginate
  # include AjaxDatatablesRails::Extensions::SimplePaginator

  include Rails.application.routes.url_helpers


  def sortable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @sortable_columns ||= ['employments.name']
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= ['employments.name']
  end

  private

  def data
    records.map do |record|
      [
        record.name,
        build_link(record)
        
      ]
    end
  end

  def get_raw_records
    # insert query here
    Employment.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
  def build_link(employment)
    icon_edit = '<span class="glyphicon glyphicon-edit"></span>'
    icon_show = '<span class="glyphicon glyphicon-info-sign"></span>'
    link = link_to(raw(icon_show), employment)
    link += link_to(raw(icon_edit), edit_employment_path(employment))
    raw('<div class="datatable-actions">'+link+'</div>')
  end  
end
