require 'cgi'

class ShortedUrl < ActiveRecord::Base
  attr_accessible :follows, :url

  validates :url, presence: true, format: {with: URL_REGEX}
  validates :follows, presence: true

  before_validation {
    self.url = CGI::unescape(self.url) if self.url != nil
    self.follows = 0 if self.follows == nil
  }

  def name
    return ShortedUrlHelper.encode(self.id)
  end

  def self.find_by_name(name)
    id = ShortedUrlHelper.decode(name)
    super.find(id)
  end
end
