class Reference < ActiveRecord::Base
  belongs_to :document,  inverse_of: :recipients
  belongs_to :entity
end
