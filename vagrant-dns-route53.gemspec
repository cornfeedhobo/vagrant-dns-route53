# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-dns-route53/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-dns-route53"
  spec.version       = VagrantPlugins::Dns::Route53::VERSION
  spec.authors       = ["cornfeedhobo"]
  spec.email         = ["cornfeedhobo@fuzzlabs.org"]

  spec.summary       = %q{Vagrant Plugin to manage AWS Route53 DNS Records}
  spec.homepage      = "https://github.com/cornfeedhobo/vagrant-dns-route53"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fog", "~> 1.22"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
