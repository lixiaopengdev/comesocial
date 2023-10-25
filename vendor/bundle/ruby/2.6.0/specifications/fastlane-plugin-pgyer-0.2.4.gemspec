# -*- encoding: utf-8 -*-
# stub: fastlane-plugin-pgyer 0.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "fastlane-plugin-pgyer".freeze
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["rexshi".freeze]
  s.date = "2022-08-30"
  s.email = "rexshi@pgyer.com".freeze
  s.homepage = "https://github.com/shishirui/fastlane-plugin-pgyer".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6".freeze)
  s.rubygems_version = "3.0.3.1".freeze
  s.summary = "distribute app to pgyer beta testing service".freeze

  s.installed_by_version = "3.0.3.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<fastlane>.freeze, [">= 2.208.0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec_junit_formatter>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["= 1.12.1"])
      s.add_development_dependency(%q<rubocop-performance>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop-require_tools>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<fastlane>.freeze, [">= 2.208.0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rspec_junit_formatter>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, ["= 1.12.1"])
      s.add_dependency(%q<rubocop-performance>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop-require_tools>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<fastlane>.freeze, [">= 2.208.0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rspec_junit_formatter>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, ["= 1.12.1"])
    s.add_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-require_tools>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
  end
end
