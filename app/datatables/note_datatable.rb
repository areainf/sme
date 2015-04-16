# class NoteDatatable < AjaxDatatablesRails::Base
#   def_delegator :@view, :link_to
#   def_delegator :@view, :raw
#   # uncomment the appropriate paginator module,
#   # depending on gems available in your project.
#   # include AjaxDatatablesRails::Extensions::Kaminari
#   include AjaxDatatablesRails::Extensions::WillPaginate
#   # include AjaxDatatablesRails::Extensions::SimplePaginator
#   include Rails.application.routes.url_helpers

#   def sortable_columns
#     # list columns inside the Array in string dot notation.
#     # Example: 'users.email'
#     @sortable_columns ||= ['documents.emission_date']
#   end

#   def searchable_columns
#     # list columns inside the Array in string dot notation.
#     # Example: 'users.email'
#     @searchable_columns ||= ['documents.recipients_ids', 'documents.senders_ids', 'documents.emission_date', 'documents.description']
#   end

#   private

#   def data
#     records.map do |record|
#       recip = record.recipients_names
#       send = record.senders_names
#       [
#         recip.blank? ? '' : recip.join("; "),
#         send.blank? ? '' : send.join("; "),
#         record.emission_date,
#         record.description,
#         build_link(record),
#       ]
#     end
#   end

#   def get_raw_records
#     # insert query here
#     Note.all    
#   end

#   # ==== Insert 'presenter'-like methods below if necessary
#   def build_link(note)
#     icon_edit = '<span class="glyphicon glyphicon-edit"></span>'
#     icon_show = '<span class="glyphicon glyphicon-info-sign"></span>'
#     link = link_to(raw(icon_show), note)
#     link += link_to(raw(icon_edit), edit_note_path(note))
#     raw('<div class="datatable-actions">'+link+'</div>')
#   end  
# end
class NoteDatatable
  include ApplicationHelper
  include DocumentsHelper
  delegate :raw, :simple_format, :params, :h, :link_to, :draw_direction, :number_to_currency, to: :@view

  # def initialize(view, current_user)
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Document.count,
        iTotalDisplayRecords: documents.count,
      aaData: data
    }
  end

private

  def data
    documents.map do |record|
      recip = record.recipients_names || []
      recip << record.recipient_text
      send = record.senders_names || []
      send << record.sender_text
      [
        draw_direction(record),
        recip.blank? ? '' : recip.join("; "),
        send.blank? ? '' : send.join("; "),
        record.emission_date,
        record.description,
        build_link(record),
      ]
    end
  end

  def documents
    fetch_documents
  end

  def fetch_documents
    if !sort_column.blank?
      documents = Document.order(sort_column)
    else
      documents = Document.order("emission_date desc")
    end
    if !params[:search][:value].blank?
      documents = documents.joins("LEFT JOIN `references` on documents.id = `references`.document_id
                                   LEFT JOIN entities on `references`.entity_id = entities.id 
                                   LEFT JOIN people on `entities`.person_id = people.id
                                   LEFT JOIN employments on `entities`.employment_id = employments.id
                                   LEFT JOIN dependencies on `entities`.dependency_id = dependencies.id")
      documents = documents.where("
                                 people.firstname like :s_search or
                                 people.lastname like :s_search or
                                 employments.name like :s_search or
                                 dependencies.name like :s_search or
                                 documents.emission_date like :s_search",
                                 s_search: "%#{params[:search][:value]}%").distinct
    end

    # entities = Entity
    # documents = documents.joins("LEFT OUTER JOIN references ON references.document_id = documents.id")
    # documents = documents.page(page).per_page(per_page)
    # if params[:sSearch].present?
    #   documents = documents.where("number = :n_search or
    #                              documents.id =  :n_search or
    #                              state ilike :s_search or
    #                              name ilike :s_search or
    #                              surname ilike :s_search or
    #                              fantasy_name ilike :s_search or
    #                              registered_name ilike :s_search",
    #                              s_search: "%#{params[:sSearch]}%",
    #                              n_search: params[:sSearch].to_i)
    # end
    # if params[:sSearch_1].present?
    #   documents = documents.where(letter: params[:sSearch_1])
    # end
    # if params[:sSearch_3].present?
    #   documents = documents.where(state: params[:sSearch_3])
    # end
    documents
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column    
    columns = %w[direction recipients senders emission_date description]
    col = params['order']['0']['column'] || 0
    dir = params['order']['0']['dir'] || 'asc'
    "#{columns[col.to_i]} #{dir}" 
  end

  # def sort_direction
  #   params[:sSortDir_0] == "desc" ? "desc" : "asc"
  # end

  def customer(invoice)
    name, path = invoice.customer.try(:complete_name) || "", invoice.customer
    link_to name, path
  end


  def build_link(invoice)
    separator = raw "&nbsp;&nbsp;&nbsp;"
    icon = "glyphicon glyphicon-info-sign"
    link = link_to(raw("<i class=\"#{icon}\"></i>"), invoice)
    link += separator
    css_icon = 'glyphicon glyphicon-remove'
    confirm = I18n.t('invoices.message_confirm_delete')
    title = I18n.t('invoices.link_title_delete')
    link += link_to(raw("<i class=\"#{css_icon}\"></i>"),invoice,
     {method: :delete, data: {confirm: confirm}, :title => title})
    link
  end
end