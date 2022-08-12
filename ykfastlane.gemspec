# frozen_string_literal: true

require_relative "lib/ykfastlane/version"

Gem::Specification.new do |spec|
  spec.name = "ykfastlane"
  spec.version = YKFastlane::VERSION
  spec.authors = ["stephen.chen"]
  spec.email = ["stephen5652@126.com"]

  spec.summary = "iOS 打包工具."
  spec.description = "基于fastlane的 iOS 打包工具."
  spec.homepage = "https://github.com/stephen5652/ykfastlane.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "https://github.com/stephen5652/ykfastlane.git"
  #
  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "https://github.com/stephen5652/ykfastlane.git"
  # spec.metadata["changelog_uri"] = "https://github.com/stephen5652/ykfastlane.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['bin/**/*', 'lib/**/*.rb', 'README.md', 'LICENSE.txt']
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'git'
  spec.add_dependency 'thor'
  spec.add_dependency 'rails'
  spec.add_dependency 'fastlane'
  spec.add_dependency 'yaml'

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
