require 'test_helper'

class ShortedUrlTest < ActiveSupport::TestCase
  test 'ShortedUrl create' do
    shortedUrl = ShortedUrl.new
    assert(shortedUrl.save, 'save must be success')
  end
  test 'ShortedUrl create with url and find' do
    shortedUrl = ShortedUrl.create(:url => 'http://ya.ru')
    loadedUrl = ShortedUrl.find(shortedUrl.id)
    assert_equal(shortedUrl.url, loadedUrl.url, 'urls must be same')
  end
end