class User < ActiveRecord::Base
  attr_accessible :email, :family_name, :name
  # @mkolganov: мелочь - лучше делить декларацию модели на логические куски
  has_many :shorted_urls
  # @mkolganov: тут тоже пробел
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
end
