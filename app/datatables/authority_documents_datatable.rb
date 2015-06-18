class AuthorityDocumentsDatatable
  include ApplicationHelper
  include DocumentsHelper
  delegate :raw, :simple_format, :params, :l, :h, :link_to, :content_tag,
           :draw_direction, :draw_type_document, :number_to_currency, to: :@view

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
      recip =  ""
      unless record.recipients_names.blank?
        record.recipients_names.each do |name|
          recip << content_tag(:span, name, class: "is_entity") << "&nbsp;"
        end
      end
      unless record.recipient_text.blank?
        record.recipient_text.split('&').each do |text|
          recip << content_tag(:span, text.strip, class: "not_is_entity") << "&nbsp;"
        end
      end
      recip = '<div class="item_entity"><div class="item_entity_inner">'+recip+"</div></div>"
      send =  ""
      unless record.senders_names.blank?
        record.senders_names.each do |name|
          send << content_tag(:span, name, class: "is_entity") << "&nbsp;"
        end
      end
      unless record.sender_text.blank?
        record.sender_text.split('&').each do |text|
          send << content_tag(:span, text.strip, class: "not_is_entity") << "&nbsp;"
        end
      end
      send = '<div class="item_entity"><div class="item_entity_inner">'+send+"</div></div>"

      [
        link_to(draw_type_document(record), record),
        draw_direction(record),
        recip.blank? ? '' : recip,
        send.blank? ? '' : send,
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
    entities = Entity.where(:dependency_id => params[:dependency_id], :employment_id => params[:employment_id])
    return [] if entities.blank?
    references = Reference.where("entity_id in (?)", entities.map(&:id))
    return [] if references.blank?
    documents = Document.where("documents.id in  (?)", references.map(&:document_id))

    if !sort_column.blank?
      documents = documents.order(sort_column)
    else
      documents = documents.order("emission_date desc")
    end
    #No incluye las notas temporales que ya han sido procesadas
    documents = documents.not_process
    
    stype = search_column("2")
    documents = documents.where({type: stype}) unless stype.blank?

    sdirection = search_column("3")
    documents = documents.where({direction: sdirection})unless sdirection.blank?
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
                                 recipient_text like :s_search or
                                 sender_text like :s_search or
                                 documents.emission_date like :s_search",
                                 s_search: "%#{params[:search][:value]}%").distinct
    end
    documents.page(page).per_page(per_page)
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