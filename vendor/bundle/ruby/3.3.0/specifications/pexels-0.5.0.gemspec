# -*- encoding: utf-8 -*-
# stub: pexels 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "pexels".freeze
  s.version = "0.5.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Pexels dev team".freeze]
  s.date = "2022-06-16"
  s.description = "See more details at https://www.pexels.com/api/documentation/".freeze
  s.email = ["api@pexels.com".freeze]
  s.homepage = "https://github.com/pexels/pexels-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4.0".freeze)
  s.rubygems_version = "3.0.3.1".freeze
  s.summary = "A simple Ruby wrapper for the Pexels API".freeze

  s.installed_by_version = "3.5.18".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<requests>.freeze, ["~> 1.0.2".freeze])
end
