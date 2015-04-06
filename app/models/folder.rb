class Folder < ActiveRecord::Base
  belongs_to :parent

  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent}

end
