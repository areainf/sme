class Dependency < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Dependency'
  has_many :children, :class_name => 'Dependency', :foreign_key => 'parent_id'

  belongs_to :master_unit
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: {:scope => :master_unit, :case_sensitive => false }

  before_save :set_master_units

  def set_master_units
    if master_unit.blank?
      par = parent
      while !par.blank? && par.master_unit.blank?
        par = par.parent
      end
      self.master_unit = par.master_unit unless par.blank?
    end
  def self.get_ancestors(who)
    @tree ||= []
    # @tree is instance variable of Document class object not document instance object
    # so: Document.get_instance_variable('@tree')
    if who.parent.nil?
      return @tree
    else
      @tree << who.parent
      get_ancestors(who.parent)
    end
  end

  def ancestors
    @ancestors ||= Dependency.get_ancestors(self)
  end

end
