class Person < ActiveRecord::Base
  has_many :entities, :dependent => :restrict_with_error
  accepts_nested_attributes_for :entities, :reject_if => lambda { |entity| entity[:dependency_id].blank? && entity[:employment_id].blank? }

  validate :validate_names
  validates :lastname, uniqueness: {:scope => :firstname}

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
private
  def create_empty_entity
    self.entities.create    
  end  

end
