# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{app_config}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christopher J Bottaro"]
  s.date = %q{2009-07-01}
  s.description = %q{Application level configuration that supports YAML config file, inheritance, ERB, and object member notation.}
  s.email = %q{cjbottaro@alumni.cs.utexas.edu}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/app_config.rb",
    "lib/closed_struct.rb",
    "test/app_config.yml",
    "test/app_config_test.rb",
    "test/development.yml",
    "test/empty1.yml",
    "test/empty2.yml"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cjbottaro/app_config}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Application level configuration.}
  s.test_files = [
    "test/app_config_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
