class Employment < ActiveRecord::Base
  validates :name, :presence => true
  validates :name, :uniqueness => { :case_sensitive => false }
  belongs_to :user
  has_many :entities, dependent: :restrict_with_error
end
