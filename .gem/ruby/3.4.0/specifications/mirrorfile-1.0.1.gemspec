# -*- encoding: utf-8 -*-
# stub: mirrorfile 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mirrorfile".freeze
  s.version = "1.0.1".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/n-at-han-k/mirrorfile/blob/main/CHANGELOG.md", "documentation_uri" => "https://github.com/n-at-han-k/mirrorfile", "homepage_uri" => "https://github.com/n-at-han-k/mirrorfile", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/n-at-han-k/mirrorfile" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nathan Kidd".freeze]
  s.bindir = "exe".freeze
  s.date = "1980-01-01"
  s.description = "Mirrorfile provides a DSL similar to Bundler's Gemfile for managing local\nmirrors of git repositories. Clone and keep repositories updated with\nsimple commands. Includes Rails/Zeitwerk integration for autoloading\nmirrored code.\n".freeze
  s.email = ["nathankidd@hey.com".freeze]
  s.executables = ["mirror".freeze]
  s.files = ["exe/mirror".freeze]
  s.homepage = "https://github.com/n-at-han-k/mirrorfile".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2.0".freeze)
  s.rubygems_version = "3.7.2".freeze
  s.summary = "Manage local mirrors of git repositories".freeze

  s.installed_by_version = "3.7.2".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.21".freeze])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.9".freeze])
end
