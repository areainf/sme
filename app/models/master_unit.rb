class MasterUnit < ActiveRecord::Base
  has_many :dependencies
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: {:case_sensitive => false}

end
