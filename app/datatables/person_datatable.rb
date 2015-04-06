class PersonDatatable < AjaxDatatablesRails::Base
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
    @sortable_columns ||= ['people.firstname', 'people.lastname']
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= ['people.firstname', 'people.lastname']
  end

  private

  def data
    records.map do |record|
      [
        record.firstname,
        record.lastname,
        build_link(record),
      ]
    end
  end

  def get_raw_records
    # insert query here
    Person.all    
  end

  # ==== Insert 'presenter'-like methods below if necessary
  def build_link(person)
    icon_edit = '<span class="glyphicon glyphicon-edit"></span>'
    icon_show = '<span class="glyphicon glyphicon-info-sign"></span>'
    link = link_to(raw(icon_show), person)
    link += link_to(raw(icon_edit), edit_person_path(person))
    raw('<div class="datatable-actions">'+link+'</div>')
  end  
end
