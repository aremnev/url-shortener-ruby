require 'test_helper'

class ShortedUrlTest < ActiveSupport::TestCase
  test 'ShortedUrl create' do
    shortedUrl = ShortedUrl.new
    assert(!shortedUrl.valid?, 'shortedUrl must not be valid without url')
    assert(!shortedUrl.save, 'save must not be success when shortedUrl invalid')

  end
  test 'ShortedUrl create with url and find' do
    shortedUrl = ShortedUrl.new(:url => 'http://yandex.ru/yandsearch?text=%D0%A3%D1%81%D0%BF%D0%B5%D1%85&lr=66')
    assert(shortedUrl.valid?, 'shortedUrl must be valid')
    assert(shortedUrl.save, 'save must be success')
    loadedUrl = ShortedUrl.find(shortedUrl.id)
    assert_equal(shortedUrl.url, loadedUrl.url, 'urls must be same')
    assert_equal(0, loadedUrl.follows)
  end
  test 'ShortedUrl create and find by name' do
    shortedUrl = ShortedUrl.new(:url => 'http://ya.ru')
    loadedUrl = ShortedUrl.find_by_name(shortedUrl.name)
    assert_equal(shortedUrl.url, loadedUrl.url, 'urls must be same')
  end
end