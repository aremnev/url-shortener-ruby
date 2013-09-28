class ShortedUrl < ActiveRecord::Base
  attr_accessible :follows, :url
  def name
    return ShortedUrlHelper.encode(self.id)
  end

  def self.find_by_name(name)
    id = ShortedUrlHelper.decode(name)
    super.find(id)
  end
end
