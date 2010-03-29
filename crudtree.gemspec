#!/usr/bin/env gem build
# encoding: utf-8
 
Gem::Specification.new do |s|
  s.name = "crudtree"
  s.version = "0.1.2"
  s.authors = ["Simon Hafner aka Tass"]
  s.homepage = "http://github.com/Tass/CRUDtree"
  s.summary = "A resource helper mainly for usher, but may be adapted for other routers as well."
  s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = ["hafnersimon", "gmail.com"].join("@")
  s.has_rdoc = true
 
  # files
  s.files = Dir.glob("{lib,test}/**/*") + %w[LICENSE README.rdoc]
  s.require_paths = ["lib"]
 
  # Ruby version
  # Current JRuby with --1.9 switch has RUBY_VERSION set to "1.9.2dev"
  # and RubyGems don't play well with it, so we have to set minimal
  # Ruby version to 1.9, even if it actually is 1.9.1
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9")
 
  # === Dependencies ===
  # RubyGems has runtime dependencies (add_dependency) and
  # development dependencies (add_development_dependency)
  s.add_dependency "extlib"
end
