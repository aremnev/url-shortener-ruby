require 'uri'

# @mkolganov: кажется, можно было бы немного упростить жизнь, назвав эту модель просто Url?
# сейчас уже не нужно ничего менять, но помни об этом, когда будешь создавать новые модели.
# из таких мелочей складывается простота/гибкость поддержки рельсы
# (отвлёкся на болтовню :-)

class ShortedUrl < ActiveRecord::Base
  belongs_to :user
  attr_accessible :follows, :url
  attr_accessor :name

  validates :url, presence: true, format: {with: /^#{URI::regexp(['http', 'https'])}$/}
  validates :follows, presence: true

  # @mkolganov: лучше do-end вместо {}
  before_validation {
    self.follows = 0 if self.follows == nil
  }

  def name
    # @mkolganov: без крайней необходимости лучше избегать вызова хелпера из модели.
    # к тому же, если этот код используется только в модели - лучше переместить его из хелпера в Concern
    ShortedUrlHelper.encode(self.id)
  end

  def self.find_by_name(name)
    id = ShortedUrlHelper.decode(name)
    find(id)
  end
end
