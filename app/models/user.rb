class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable,
  delegate :can?, :cannot?, :to => :ability
  
  devise  :database_authenticatable, :recoverable, :rememberable, 
          :trackable, :validatable, :timeoutable, :timeout_in => 60.minutes
  has_many :events
  has_many :documents_created, :foreign_key => :create_user_id, :class_name => "Document"
  has_many :documents_entries, :foreign_key => :entry_user_id, :class_name => "Document"
  has_many :dependencies
  has_many :employments
  has_many :entities
  has_many :folders
  has_many :master_units
  has_many :people, :foreign_key => :create_user_id, :class_name => "Person"
  has_one :permission

  def is_admin?
    self.role == ApplicationHelper::ROLE_ADMIN
  end

  def is_dependency?
    self.role == ApplicationHelper::ROLE_DEPENDENCY
  end

  def is_reception?
    self.role == ApplicationHelper::ROLE_RECEPTION
  end

  def temporary_notes
    documents_created.where(type: TemporaryNote.name)
  end
  #add for check if a user != of current_user has ability for
  def ability
    @ability ||= Ability.new(self)
  end
  
  def self.dependency_without_persmission
    ids = Permission.all.map{|p| p.user_id}    
    users =  where(:role =>  ApplicationHelper::ROLE_DEPENDENCY)
    users =  users.where("id not in (?)", ids) unless ids.blank?
    users  
  end

end
