module DocumentsHelper
  SYSTEM_STATUS = %w(archived circulation)
  DOCUMENT_TYPES = %w{Note Expedient TemporaryNote}

  def optSel_SystemStatus
    SYSTEM_STATUS.map { |t| [I18n.t("documents.system_status.#{t}"), t]}
  end

  def optSel_Types
    DOCUMENT_TYPES.map { |t| [I18n.t("documents.type.#{t}"), t]}
  end

  def optSel_Directions
    [[I18n.t("documents.directions.input"), 1],
    [I18n.t("documents.directions.output"), ApplicationHelper::DIR_OUTPUT]]
  end

  def entities_data_pre(references)
    data = []
    references.each do |ref|
      data << ref.entity.to_json({:methods => [:name], :include => [:person, :dependency, :employment]})
    end
    data.to_json
  end
  
  def draw_direction(document)
    klass = document.is_input? ? 'dir_input' : 'dir_output'
    text = document.is_input? ? 'input' : 'output'
    text = I18n.t("documents.directions.#{text}")
    simple_format text, class: klass
  end

  def draw_type_document(document)
    klass = "label_type_#{document.type.downcase}"
    text = I18n.t("documents.type.#{document.type}")
    simple_format text, class: klass
  end
end