class Entity < ActiveRecord::Base
  belongs_to :person
  belongs_to :employment
  belongs_to :dependency
  belongs_to :user
  has_many :senders
  has_many :recipients
  validate :valid_entity
  validate :unique_entity, :before => :create
  def valid_entity
    (self.person.present? || self.employment.present?) && dependency.present?
  end

  def unique_entity
    p_id = self.person_id.blank? ? nil : self.person_id
    d_id = self.dependency_id.blank? ? nil : self.dependency_id
    e_id = self.employment_id.blank? ? nil : self.employment_id
    if ! Entity.where(:person_id => p_id, :dependency_id => d_id, :employment_id => e_id).empty?
      errors.add(:base, I18n.t('activerecord.errors.models.entity.unique'))
      false
    end
  end
  def fullname
    name = []
    if person.present? then name << person.fullname end
    if employment.present? then name << employment.name end
    if dependency.present? then name << dependency.name end
    name.join(' - ')
  end
  
  def root?
    self.dependency.nil? && self.employment.nil?
  end

end
