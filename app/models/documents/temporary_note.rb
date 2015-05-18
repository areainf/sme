class TemporaryNote < Document
  SYS_STATUS_TEMPORARY = 'temporary'
  SYS_STATUS_TEMPORARY_ENTER = 'temporary_enter'

  #=Relations
  belongs_to :final_document, :class_name => "Document", :inverse_of => :temporary_document

  #initialize object
  after_initialize :defaults
  before_save :initial_values, if: Proc.new { |tmp| tmp.code.blank? }
  before_save :update_system_status, unless: Proc.new { |tmp| tmp.final_document_id.blank? }
  
  #Temporary note always is INPUT
  def defaults
    self.direction ||=  DIR_IN
  end

  def initial_values
    generate_code
    self.system_status = SYS_STATUS_TEMPORARY
  end
  
  def update_system_status
    if self.system_status.blank? || self.system_status == SYS_STATUS_TEMPORARY
      self.system_status = SYS_STATUS_TEMPORARY_ENTER
    end
  end

  def self.nextCode(date)
    precode=date.strftime("%Y")
    last_note=TemporaryNote.unscoped.where(["code LIKE ?","%"+precode]).order(:code => :desc).first
    nextnumber = 1
    if last_note != nil then
        code_ant=last_note.code
        lastnumber=code_ant[0..precode.size]
        while lastnumber.sub!(/^0/, '') do end
        nextnumber = lastnumber.to_i + 1
    end
    sprintf( "tmp%05d", nextnumber )+precode
  end


  def generate_code
    self.code = TemporaryNote.nextCode(Time.now) if self.code.nil?
  end
end

