class Document < ActiveRecord::Base
  belongs_to :create_user_id
  belongs_to :entry_user_id
  belongs_to :folder
  has_many :recipients,  inverse_of: :document
  has_many :senders
  has_many :entities_to, through:  :recipients
  has_many :entities_from, through: :senders, :class_name => "Entity"
  # serialize  :recipients_ids, Array
  # serialize  :senders_ids, Array
  accepts_nested_attributes_for :recipients,:allow_destroy => true
  accepts_nested_attributes_for :senders, :allow_destroy => true

  validates :description, presence: true
  validates :emission_date, presence: true
  validates :senders, presence: true
  validates :recipients, presence: true
    
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
