require 'uri'

class ShortedUrl < ActiveRecord::Base
  belongs_to :user
  attr_accessible :follows, :url
  attr_accessor :name

  validates :url, presence: true
  validates :follows, presence: true

  before_validation {
    self.follows = 0 if self.follows == nil
  }

  def name
    ShortedUrlHelper.encode(self.id)
  end

  def self.find_by_name(name)
    id = ShortedUrlHelper.decode(name)
    find(id)
  end
end
