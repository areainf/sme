class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable,
  
  devise  :database_authenticatable, :recoverable, :rememberable, 
          :trackable, :validatable, :timeoutable, :timeout_in => 60.minutes
  has_many :events

  def is_admin?
    self.role == ApplicationHelper::ROLE_ADMIN
  end

  def is_dependency?
    self.role == ApplicationHelper::ROLE_DEPENDENCY
  end

  def is_reception?
    self.role == ApplicationHelper::ROLE_RECEPTION
  end
end
