# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "coffeebrew_jekyll_paginate/version"

Gem::Specification.new do |spec| # rubocop:disable Gemspec/RequireMFA
  spec.name          = "coffeebrew_jekyll_paginate"
  spec.version       = Coffeebrew::Jekyll::Paginate::VERSION
  spec.authors       = ["Coffee Brew Apps"]
  spec.email         = ["coffeebrewapps@gmail.com"]

  spec.summary       = "A Jekyll plugin to generate pagination for site collections"
  spec.description   = "A Jekyll plugin to generate pagination for site collections"
  spec.homepage      = "https://coffeebrewapps.com/coffeebrew_jekyll_paginate"
  spec.license       = "MIT"

  raise "RubyGems 2.0 or newer is required to protect against public gem pushes." unless spec.respond_to?(:metadata)

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files            = Dir["lib/**/*.rb", "lib/**/*.yml"]
  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE"]
  spec.require_paths    = ["lib/coffeebrew_jekyll_paginate", "lib"]

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_dependency "jekyll", ">= 4.0", "< 5.0"
end
