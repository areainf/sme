class Permission < ActiveRecord::Base
  belongs_to :user
  serialize :dependencies, Array
  serialize :employments, Array

  validates :user_id, presence: true, uniqueness: true

  before_save :remove_empty

  def remove_empty
    self.dependencies = self.dependencies - [''] if self.dependencies.count > 1
    self.employments = self.employments - [''] if self.employments.count > 1    
  end

  def dependency_names
    self.dependencies.inject([]){ | res, elem |
      if elem.blank?
        res << I18n.t('permissions.dependencies_all')
      else
        res << Dependency.find(elem).name
      end
    }.join(",  ")
  end

  def employment_names
    self.employments.inject([]){ | res, elem |
      if elem.blank?
        res << I18n.t('permissions.employments_all')
      else
        res << Employment.find(elem).name
      end
    }.join(",  ")
  end

  def dependencies_ids
    dependencies.map{|s| s.to_i}
  end

  def employments_ids
    employments.map{|s| s.to_i}
  end

  def entities
    dep_ids = dependencies_ids
    emp_ids = employments_ids
    dep_is_all = dep_ids.include? 0
    emp_is_all = emp_ids.include? 0
    entities = Entity.all
    entities = entities.where("dependency_id in (?)", dep_ids) unless dep_is_all
    entities = entities.where("employment_id in (?)", emp_ids) unless emp_is_all
    entities
  end

end
