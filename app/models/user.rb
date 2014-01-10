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
  has_many :messages

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates_uniqueness_of :email


  def get_main_currency
    currencies.find_by(sequence_status: 0)
  end

end
