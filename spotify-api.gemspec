# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{spotify-api}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Berkel"]
  s.date = %q{2009-08-07}
  s.default_executable = %q{spotify-api-server}
  s.description = %q{an api for spotify, based on jotify}
  s.email = %q{jan.berkel@gmail.com}
  s.executables = ["spotify-api-server"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION.yml",
     "bin/spotify-api-server",
     "examples/create_playlist.rb",
     "examples/list_playlists.rb",
     "examples/search.rb",
     "lib/jars/jotify.jar",
     "lib/jotify.rb",
     "lib/jotify/api.rb",
     "lib/jotify/media.rb",
     "spec/integration_spec.rb",
     "spec/jotify/api_spec.rb",
     "spec/jotify/media_spec.rb",
     "spec/jotify_spec.rb",
     "spec/spec_helper.rb",
     "spotify-api.gemspec"
  ]
  s.homepage = %q{http://github.com/jberkel/spotify-api}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{an api for spotify, based on jotify}
  s.test_files = [
    "spec/integration_spec.rb",
     "spec/jotify/api_spec.rb",
     "spec/jotify/media_spec.rb",
     "spec/jotify_spec.rb",
     "spec/spec_helper.rb",
     "examples/create_playlist.rb",
     "examples/list_playlists.rb",
     "examples/search.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<rack-test>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
      s.add_runtime_dependency(%q<json-jruby>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<json-jruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<json-jruby>, [">= 0"])
  end
end
