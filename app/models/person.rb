class Person < ActiveRecord::Base
  has_many :entities

  validate :validate_names

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
