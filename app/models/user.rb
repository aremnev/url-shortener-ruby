class User < ActiveRecord::Base
  attr_accessible :email, :family_name, :name
  has_many :shorted_urls

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
end
