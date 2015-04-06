class Employment < ActiveRecord::Base
  validate :name, precence: true
  validates :name, uniqueness: true
end
