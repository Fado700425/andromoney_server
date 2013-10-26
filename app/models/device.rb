class Device < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :uuid, scope: [ :user_id ]
end
