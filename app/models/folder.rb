class Folder < ActiveRecord::Base
  belongs_to :parent
  has_many :documents
  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent}

  scope :root, -> { where("parent_id is NULL") }

  def childs
    Folder.where(:parent_id, self.id)
  end
end
