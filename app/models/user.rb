class User < ActiveRecord::Base
  has_many :records
  has_many :categories
  has_many :payees
  has_many :currencies
  has_many :payments
  has_many :periods
  has_many :projects
  has_many :prefs
  has_many :subcategories
  has_many :devices

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
end
