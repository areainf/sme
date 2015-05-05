class Attachment < ActiveRecord::Base
  belongs_to :document
  validates   :document, presence: true
  mount_uploader :filedoc, ScandocUploader

end
