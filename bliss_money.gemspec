# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "bliss_money"
  s.version     = "1.0.1.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Luetke", "Hongli Lai", "Jeremy McNevin",
                   "Shane Emmons", "Simone Carletti", "Fadendaten"]
  s.email       = ["support@fadendaten.ch"]
  s.homepage    = "http://www.fadendaten.ch"
  s.summary     = "Money and currency exchange support library."
  s.description = "This library aids one in handling money and different currencies."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "i18n", "~> 0.4"
  s.add_dependency "json"

  
  s.add_development_dependency "activerecord", "3.0.5"
  s.add_development_dependency "rspec",        "~> 2.9.0"
  s.add_development_dependency "yard",         "~> 0.7.5"
  s.add_development_dependency "redcarpet",    "~> 2.1.1"
  s.add_development_dependency "guard",        "~> 1.0.1"
  s.add_development_dependency "spork",        "~> 0.9.0"
  s.add_development_dependency "guard-spork",  "~> 0.6.1"
  s.add_development_dependency "guard-rspec",  "~> 0.7.0"

  s.requirements << "json"

  s.files =  Dir.glob("{config,lib,spec}/**/*")
  s.files += %w(CHANGELOG.md LICENSE README.md)
  s.files += %w(Rakefile .gemtest bliss_money.gemspec)

  s.require_path = "lib"
end
