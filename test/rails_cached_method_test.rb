require "test_helper"

class RailsCachedMethodTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
  end

  test "it has a version number" do
    assert RailsCachedMethod::VERSION
  end

  test "it can cache simple things" do
    a = User.create(name: 'John', age: 100)
    b = User.create(name: 'Bob', age: 99)

    assert_equal 100, User.cached.maximum(:age)
    a.destroy
    assert_equal 100, User.cached.maximum(:age)

    assert_equal 99, User.cached(recache: true).maximum(:age)
    assert_equal 99, User.cached.maximum(:age)

    assert_equal 199, (User.cached.maximum(:age) + 100)
  end

  test "with relations" do
    a = User.create(name: 'John', age: 100)
    b = User.create(name: 'Bob', age: 99)

    ac = a.comments.create
    bc = b.comments.create

    assert a.cached.comments.count > 0
    assert a.cached.comments.any?
    assert_equal 1, a.cached.comments.count
    assert_equal 1, a.cached.comments.count
    assert_equal ac, a.cached.comments.first

    ac.destroy
    assert_equal ac, a.cached.comments.first
    a.reload
    assert_nil a.comments.first
    assert_nil a.cached(recache: true).comments.first
  end

  test 'in associations' do
    a = User.create(name: 'John', age: 100)
    b = User.create(name: 'Bob', age: 99)

    ac = a.comments.create
    bc1 = b.comments.create
    bc2 = b.comments.create

    assert_equal 2, User.cached.where(name: 'Bob').first.comments.count
    assert_equal 2, User.where(name: 'Bob').first.comments.count

    assert_equal b, User.cached.where(name: 'Bob').first.comments.first.user
    assert_equal b, User.where(name: 'Bob').first.comments.first.user
  end

  test 'in methods' do
    a = User.create(name: 'John', age: 100)
    b = User.create(name: 'Bob', age: 99)

    assert_equal 100, User.cached.find_maximum_age
    a.destroy
    assert_equal 100, User.cached.find_maximum_age
    assert_equal 99, User.cached(recache: true).find_maximum_age

    bc = b.comments.create

    c = User.cached.first.last_comment
    assert_equal c, bc

    e = Comment.cached.find_maximum_age
    assert_equal 'n/a', e
  end
end
