class Folder < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Folder', :foreign_key => 'parent_id'
  has_many :documents
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent}
  validate :no_recursive

  before_destroy :validate_no_children

  scope :root, -> { where("parent_id is NULL") }

  def childs
    Folder.where({:parent_id => self.id})
  end
  def no_recursive
    p = parents
    if !id.nil? && !p.blank? && p.include?(id)
      errors.add(:base,"Carpeta Recursiva")
      return false
    end
    true
  end
  def parents
    if self.parent_id.blank?
      return
    end
    return [self.parent_id] << self.parent.parents
  end

  def path
    if self.parent.present?
      self.parent.path + "/" + name 
    else
      name
    end
  end

  def validate_no_children
    if childs.count != 0
      errors.add(:name, I18n.t("activerecord.models.errors.message_non_empty_folder"))
      raise I18n.t("activerecord.models.errors.message_non_empty_folder") 
      false
    end
    true
  end
end
