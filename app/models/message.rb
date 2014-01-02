class Message < ActiveRecord::Base
  belongs_to :user

  scope :not_read, -> { where(is_read: false) }
  default_scope { order('created_at DESC') }

  validates_presence_of :user_id, :context
end
