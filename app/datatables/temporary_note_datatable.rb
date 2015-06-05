class TemporaryNoteDatatable
  include ApplicationHelper
  include DocumentsHelper
  delegate :raw, :simple_format, :params, :h, :l, :link_to, :draw_direction, :draw_type_document, :number_to_currency, to: :@view

  # def initialize(view, current_user)
  def initialize(view, user)
    @view = view
    @user = user
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @user.temporary_notes.count,
        iTotalDisplayRecords: documents.count,
      aaData: data.compact #remove nil #line 25
    }
  end

private

  def data
    documents.map do |record|
      next if record.is_a?(TemporaryNote) &&  record.document.present?
      recip = record.recipients_names || []
      recip << record.recipient_text.gsub('&', '; ') 
      send = record.senders_names || []
      send << record.sender_text.gsub('&', '; ') 
      [
        draw_type_document(record),
        #draw_direction(record),
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
    documents = Document.joins("LEFT JOIN `references`  on documents.id = `references`.document_id").where(
      "`references`.entity_id in (?) or documents.create_user_id = ?", @user.permission.entities.map{|ent| ent.id}, @user.id).distinct
    #documents = documents.sort(sort_column.blank? ? "emission_date desc" : sort_column)
    # if !sort_column.blank?
    #   documents = @user.temporary_notes.order(sort_column)
    # else
    #   documents = @user.temporary_notes.order("emission_date desc")
    # end
    if !params[:search][:value].blank?
      documents = documents.joins("
                                   LEFT JOIN entities on `references`.entity_id = entities.id 
                                   LEFT JOIN people on `entities`.person_id = people.id
                                   LEFT JOIN employments on `entities`.employment_id = employments.id
                                   LEFT JOIN dependencies on `entities`.dependency_id = dependencies.id")
      documents = documents.where("
                                 people.firstname like :s_search or
                                 people.lastname like :s_search or
                                 employments.name like :s_search or
                                 dependencies.name like :s_search or
                                 sender_text like :s_search or
                                 recipient_text like :s_search or
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
    columns = %w[direction recipients senders emission_date description]
    col = params['order']['0']['column'] || 0
    dir = params['order']['0']['dir'] || 'asc'
    "#{columns[col.to_i]} #{dir}" 
  end


  def build_link(document)
    separator = raw "&nbsp;&nbsp;&nbsp;"
    icon = "glyphicon glyphicon-info-sign"
    link = link_to(raw("<i class=\"#{icon}\"></i>"), document)
    if @user.can? :destroy, document
      link += separator
      css_icon = 'glyphicon glyphicon-remove'
      confirm = I18n.t('documents.message_confirm_delete')
      title = I18n.t('documents.link_title_delete')
      link += link_to(raw("<i class=\"#{css_icon}\"></i>"),document,
       {method: :delete, data: {confirm: confirm}, :title => title})
    end
    link
  end
end