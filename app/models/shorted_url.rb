require 'uri'

class ShortedUrl < ActiveRecord::Base
  belongs_to :user
  attr_accessible :follows, :url
  attr_accessor :name

  validates :url, presence: true, format: {with: /^#{URI::regexp(['http', 'https'])}$/}
  validates :follows, presence: true

  before_validation do
    self.follows = 0 if self.follows == nil
  end

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
