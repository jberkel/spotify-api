# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{spotify-api}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Berkel"]
  s.date = %q{2009-08-03}
  s.default_executable = %q{server}
  s.description = %q{an api for spotify, based on jotify}
  s.email = %q{jan.berkel@gmail.com}
  s.executables = ["server"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION.yml",
     "bin/server",
     "jars/jotify.jar",
     "jars/json.jar",
     "lib/api.rb",
     "lib/jotify.rb"
  ]
  s.homepage = %q{http://github.com/jberkel/spotify-api}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{an api for spotify, based on jotify}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
      s.add_runtime_dependency(%q<json-jruby>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<json-jruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<json-jruby>, [">= 0"])
  end
end
