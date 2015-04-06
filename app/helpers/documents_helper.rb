module DocumentsHelper
  SYSTEM_STATUS = %w(archived circulation)

  def optSel_SystemStatus
    SYSTEM_STATUS.map { |t| [I18n.t("documents.system_status.#{t}"), t]}
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
end