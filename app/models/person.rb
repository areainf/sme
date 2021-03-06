class Person < ActiveRecord::Base
  has_many :entities, :dependent => :restrict_with_error
  belongs_to :create_user, :class_name => "User"

  accepts_nested_attributes_for :entities, :reject_if => lambda { |entity| entity[:dependency_id].blank? && entity[:employment_id].blank? }

  validate :validate_names
  validates :lastname, uniqueness: {:scope => :firstname, :case_sensitive => false}

  after_create :create_empty_entity
  
  def validate_names
    if self.firstname.blank? && self.lastname.blank?
      errors.add(:lastname, I18n.t('activerecord.models.errors.message_empty_people_names'))
    end
  end
  def fullname
    name = []
    if !self.lastname.blank? then name << self.lastname end
    if !self.firstname.blank? then name << self.firstname end
    name.join(", ")
  end

  def documents
    #ap a.entities.map{|x| x.recipients.map{|y| y.document} + x.senders.map{|z| z.document}}
    docs = []
    ids_entities = self.entities.map(&:id)
    ref = Reference.where("entity_id in (?)", ids_entities)
    ref.each do |r|
      docs << r.document if r.document.present?
    end
    docs

    # .each do |entity|
    #   entity.recipients.each do |recipient|
    #     docs << recipient.document
    #   end unless entity.recipients.blank?
    #   entity.senders.each do |sender|
    #     docs << sender.document
    #   end unless entity.senders.blank?
    # end unless self.entities.blank?
    # docs
  end
private
  def create_empty_entity
    self.entities.create    
  end  

end
