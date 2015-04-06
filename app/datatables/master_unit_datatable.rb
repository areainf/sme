class MasterUnitDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :raw  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  # include AjaxDatatablesRails::Extensions::Kaminari
  include AjaxDatatablesRails::Extensions::WillPaginate
  # include AjaxDatatablesRails::Extensions::SimplePaginator
  include Rails.application.routes.url_helpers

  def sortable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @sortable_columns ||= ['master_units.name']
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= ['master_units.name']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name,
        build_link(record)
      ]
    end
  end

  def get_raw_records
      MasterUnit.all    
  end

  # ==== Insert 'presenter'-like methods below if necessary
  def build_link(master_u)
    icon_edit = '<span class="glyphicon glyphicon-edit"></span>'
    icon_show = '<span class="glyphicon glyphicon-info-sign"></span>'
    link = link_to(raw(icon_show), master_u)
    link += link_to(raw(icon_edit), edit_master_unit_path(master_u))
    raw('<div class="datatable-actions">'+link+'</div>')
  end  
end
