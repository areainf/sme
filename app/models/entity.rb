class Entity < ActiveRecord::Base
  belongs_to :person
  belongs_to :employment
  belongs_to :dependency
  belongs_to :user
  has_many :senders
  has_many :recipients
  validate :valid_entity

  def valid_entity
    (self.person.present? || self.employment.present?) && dependency.present?
  end
  def fullname
    name = []
    if person.present? then name << person.fullname end
    if employment.present? then name << employment.name end
    if dependency.present? then name << dependency.name end
    name.join(' - ')
  end

end
