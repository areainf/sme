class TemporaryNote < Document
  #initialize object
  after_initialize :defaults
  before_save :initial_values, if: Proc.new { |tmp| tmp.code.blank? }
  #Temporary note always is INPUT
  def defaults
    self.direction ||=  DIR_IN
  end

  def initial_values
    generate_code
    system_status = SYS_STATUS_TEMPORARY
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

