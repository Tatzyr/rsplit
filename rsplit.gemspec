lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rsplit/version"

Gem::Specification.new do |spec|
  spec.name = "rsplit"
  spec.version = RSplit::VERSION
  spec.authors = ["Tatsuya Otsuka"]
  spec.email = ["tatzyr@gmail.com"]

  spec.summary = "Divides string into substrings based on a delimiter (starting from right), returning an array of these substrings."
  spec.homepage = "https://github.com/tatzyr/rsplit"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.license = "Zlib"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "standard"
end
