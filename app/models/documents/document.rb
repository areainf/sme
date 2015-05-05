class Document < ActiveRecord::Base
  belongs_to :create_user, :class_name => "User"
  belongs_to :entry_user, :class_name => "User"
  belongs_to :folder
  has_many :recipients,  inverse_of: :document
  has_many :senders
  has_many :entities_to, through:  :recipients
  has_many :entities_from, through: :senders, :class_name => "Entity"
  has_many :events
  has_many :attachments, :inverse_of => :document, :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  # serialize  :recipients_ids, Array
  # serialize  :senders_ids, Array
  accepts_nested_attributes_for :recipients,:allow_destroy => true
  accepts_nested_attributes_for :senders, :allow_destroy => true

  validates :description, presence: true
  validates :emission_date, presence: true
  validates :senders, presence: true , if: Proc.new { |a| a.sender_text.blank? } 
  validates :recipients, presence: true, if: Proc.new { |a| a.recipient_text.blank? } 
    
  def is_input?
    direction.presence && direction.to_i != 0
  end
 
  def recipients_names
    recipients.map{|x| x.entity.fullname}  unless recipients.blank?
  end

  def senders_names
    senders.map{|x| x.entity.fullname}  unless senders.blank?
  end
end
