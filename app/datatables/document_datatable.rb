class DocumentDatatable
  include ApplicationHelper
  include DocumentsHelper
  delegate :raw, :simple_format, :params, :l, :h, :link_to, :draw_direction, :draw_type_document, :number_to_currency, to: :@view

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
        link_to(draw_type_document(record), record),
        draw_direction(record),
        recip.blank? ? '' : recip.join("; "),
        send.blank? ? '' : send.join("; "),
        l(record.emission_date),
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
    #No incluye las notas temporales que ya han sido procesadas
    documents = documents.not_process.page(page).per_page(per_page)
    stype = search_column("0")
    if !stype.blank?
      documents = documents.where({type: stype})
    end
    sdirection = search_column("1")
    if !sdirection.blank?
      documents = documents.where({direction: sdirection})
    end
    sdate = search_column("4")
    if !sdate.blank?
      arr_dates = sdate.split(" - ")
      documents = documents.where("emission_date BETWEEN ? AND ?", "#{arr_dates[0]}", "#{arr_dates[1]}")
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

    documents
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column    
    columns = %w[type direction recipients senders emission_date description]
    col = params['order']['0']['column'] || 0
    dir = params['order']['0']['dir'] || 'asc'
    "#{columns[col.to_i]} #{dir}" 
  end


  def build_link(document)
    separator = raw "&nbsp;&nbsp;&nbsp;"
    icon = "glyphicon glyphicon-info-sign"
    link = link_to(raw("<i class=\"#{icon}\"></i>"), document)
    link += separator
    # css_icon = 'glyphicon glyphicon-remove'
    # confirm = I18n.t('documents.message_confirm_delete')
    # title = I18n.t('documents.link_title_delete')
    # link += link_to(raw("<i class=\"#{css_icon}\"></i>"),document,
    #  {method: :delete, data: {confirm: confirm}, :title => title})
    link
  end

  def search_column(index)
    begin
      params['columns'][index]['search']['value']
    rescue
      nil
    end

  end
end