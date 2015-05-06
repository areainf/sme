class Dependency < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Dependency'
  has_many :children, :class_name => 'Dependency', :foreign_key => 'parent_id'

  belongs_to :master_unit
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: {:scope => :master_unit, :case_sensitive => false }

end
