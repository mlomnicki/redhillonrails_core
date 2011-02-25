# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redhillonrails_core/version"

Gem::Specification.new do |s|
  s.name        = "redhillonrails_core"
  s.version     = RedhillonrailsCore::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michał Łomnicki"]
  s.email       = ["michal.lomnicki@gmail.com"]
  s.homepage    = "https://github.com/mlomnicki/redhillonrails_core"
  s.summary     = "Adds support in ActiveRecord for foreign_keys, complex indexes and other database-related stuff"
  s.description = "Adds support in ActiveRecord for foreign_keys, complex indexes and other database-related stuff. Easily create foreign_keys, complex indexes and views."

  s.rubyforge_project = "redhillonrails_core"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("activerecord", ">= 2")

  s.add_development_dependency("rspec", "~> 2.4.0")
  s.add_development_dependency("pg")
  s.add_development_dependency("mysql")
  s.add_development_dependency("mysql2")
  s.add_development_dependency("sqlite3-ruby", "~> 1.3.1")
end
