require_relative "lib/rails_cached_method/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_cached_method"
  spec.version     = RailsCachedMethod::VERSION
  spec.authors     = ["Igor Kasyanchuk"]
  spec.email       = ["igorkasyanchuk@gmail.com"]
  spec.homepage    = "http://github.com/igorkasyanchuk/rails_cached_method"
  spec.summary     = "Very easy way to cache results of your methods"
  spec.description = "Very easy way to cache results of your methods"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"
end
