class Document < ActiveRecord::Base
  DIR_OUT = 0
  DIR_IN = 1
  belongs_to :create_user, :class_name => "User"
  belongs_to :entry_user, :class_name => "User"
  belongs_to :folder
  has_many :recipients,  inverse_of: :document
  has_many :senders
  has_many :entities_to, through:  :recipients
  has_many :entities_from, through: :senders, :class_name => "Entity"
  has_many :events
  has_many :attachments, :inverse_of => :document, :dependent => :destroy
  
  belongs_to :temporary, :class_name => "TemporaryNote", :foreign_key => "temporary_id", autosave: true 

  # serialize  :recipients_ids, Array
  # serialize  :senders_ids, Array
  accepts_nested_attributes_for :recipients,:allow_destroy => true
  accepts_nested_attributes_for :senders, :allow_destroy => true
  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :description, presence: true
  validates :emission_date, presence: true
  validates :senders, presence: true , if: Proc.new { |a| a.sender_text.blank? } 
  validates :recipients, presence: true, if: Proc.new { |a| a.recipient_text.blank? } 

  #= Scopes
  #scope :not_process, -> { where("id not in (?)", Document.where('temporary_id is not null').map{|x| x.temporary_id})}
   
  after_create :update_temporary_state

  def self.not_process
    #notas temporales procesadas
    process_tempnotes = Document.where('temporary_id is not null').map{|x| x.temporary_id}
    if process_tempnotes.blank?
      self.all
    else
      self.where("documents.id not in (?)",process_tempnotes )
    end
  end

  def is_input?
    direction.presence && direction.to_i != DIR_OUT
  end
 
  def recipients_names
    recipients.map{|x| x.entity.fullname}  unless recipients.blank?
  end

  def senders_names
    senders.map{|x| x.entity.fullname}  unless senders.blank?
  end

  def update_temporary_state
    unless self.temporary.blank?
      self.temporary.update_status(self)
      self.temporary.save
    end
  end

end
