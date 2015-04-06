class Note < Document
  before_save :finish_note
  def finish_note
    set_entry_date
    generate_code
  end

  def self.nextCode(date)
    precode=date.strftime("%Y")
    last_note=Note.unscoped.where(["code LIKE ?","%"+precode]).order(:code => :desc).first
    nextnumber = 1
    if last_note != nil then
        code_ant=last_note.code
        lastnumber=code_ant[0..precode.size]
        while lastnumber.sub!(/^0/, '') do end
        nextnumber = lastnumber.to_i + 1
    end
    sprintf( "%05d", nextnumber )+precode
  end


  def generate_code
    Rails.logger.info(ap entry_at)
    self.code = Note.nextCode(self.entry_at) if self.code.nil?
  end

  def set_entry_date
    self.entry_at = Time.now # entry_at.blank?
  end

  def senders_name
    
  end
end
