require 'test_helper'

class ShortedUrlHelperTest < ActiveSupport::TestCase
  test 'simpleEncodeDecode' do
    test_id = 7
    shortedUrl = ShortedUrlHelper.encode(test_id)
    assert(shortedUrl.blank? == false, 'Shorted url must not be blank')
    assert_equal(test_id, ShortedUrlHelper.decode(shortedUrl), 'Decoded id must be equal to initial id')
  end
end