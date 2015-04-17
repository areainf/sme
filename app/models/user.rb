class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable,
  
  devise  :database_authenticatable, :recoverable, :rememberable, 
          :trackable, :validatable, :timeoutable, :timeout_in => 60.minutes
  has_many :events

end
