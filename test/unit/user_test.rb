require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'Should create correct user' do
    user = User.new(:email => 'valid@email.com', :name => 'Lincoln')
    assert(user.save, 'save must be success')
    assert(user.valid?, 'user must be valid')
  end
  test 'Should not create user without name' do
    user = User.new(:email => 'otherValid@email.com')
    assert(!user.save, 'save must not be success without name')
    assert(!user.valid?, 'user must not be valid without name')
  end
  test 'Should not create user without email' do
    user = User.new(:name => 'Lincoln')
    assert(!user.save, 'save must not be success without email')
    assert(!user.valid?, 'user must not be valid without email')
  end
  test 'Should not create user with incorrect email' do
    user = User.new(:email => 'invalid@email,com', :name => 'Lincoln')
    assert(!user.save, 'save must not be success with incorrect email')
    assert(!user.valid?, 'user must not be valid with incorrect email')
  end
end
