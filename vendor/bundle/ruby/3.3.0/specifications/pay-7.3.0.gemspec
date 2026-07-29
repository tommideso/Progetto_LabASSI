# -*- encoding: utf-8 -*-
# stub: pay 7.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "pay".freeze
  s.version = "7.3.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jason Charnes".freeze, "Chris Oliver".freeze, "Collin Jilbert".freeze]
  s.date = "2024-07-09"
  s.description = "Stripe, Paddle, and Braintree payments for Ruby on Rails apps".freeze
  s.email = ["jason@thecharnes.com".freeze, "excid3@gmail.com".freeze, "cjilbert504@gmail.com".freeze]
  s.homepage = "https://github.com/pay-rails/pay".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.5.13".freeze
  s.summary = "Payments engine for Ruby on Rails".freeze

  s.installed_by_version = "3.5.18".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<rails>.freeze, [">= 6.0.0".freeze])
end
