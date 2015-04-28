class MasterUnit < ActiveRecord::Base
  has_many :dependencies

  validates :name, presence: true
  validates :name, uniqueness: {:case_sensitive => false}

end
