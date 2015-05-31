# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_partition/version'

Gem::Specification.new do |s|
  s.name          = "easy_partition"
  s.version       = EasyPartition::VERSION
  s.authors       = ["Daniel Carneiro"]
  s.email         = ["daniel.carneiro@nmusic.pt"]

  s.summary       = %q{A gem to manage postgres partitions.}
  s.description   = %q{A gem to manage postgres partitions only using the rails migration files to do it.}
  s.homepage      = "https://github.com/dcarneiro/easy_partition"

  # # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # # delete this section to allow pushing this gem to any host.
  # if s.respond_to?(:metadata)
  #   s.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", "~> 3.0"

  s.add_development_dependency "bundler", "~> 1.9"
  s.add_development_dependency "minitest"
  s.add_development_dependency "rake", "~> 10.0"
end
