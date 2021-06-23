# Rails Cached Method

Simple way to cache results of methods. Using `Rails.cache` inside with default expiration time of 1 minute.

![Demo](docs/rails_cached_method.png)

## Usage

To get a value and cache it just write a code like:

```ruby
User.cached.admins
post.cached.comments.last
User.cached.where(role: :moderator).count
Project.cached.first.some_heavey_method
```

So basically just call method `cached` on any object. It will wrap and cache **every** result from the next method call. So every result from method chain is cached.

For example:

```ruby
post.cached.comments.first # A
post.cached.comments.last  # B
```

Here `post.cached.comments` will return same collection.

You don't need to specify a key, because it's dynamically set based on object, arguments, etc.

Options:

```ruby
cached(key: nil, expires_in: 1.minute, recache: false)
```

key - you can set your key.
expires_in - TTL of cached object.
recache - should be key deleted and cached again.


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_cached_method'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails_cached_method
```

## TODO

- think if rails dependency could be replaced with something more lightweight

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
