# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jagg/constants'

Gem::Specification.new do |spec|
  spec.name          = 'jagg'
  spec.version       = JAGG::VERSION
  spec.authors       = ['Nialto Services']
  spec.email         = ['support@nialtoservices.co.uk']

  spec.summary       = %q{Just Another Gravatar Gem}
  spec.description   = %q{This gem uses the Gravatar API to provide you with both profile and image data.}
  spec.homepage      = 'https://github.com/nialtoservices/jagg'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'argspec', '~> 0.3', '>= 0.3.3'
  spec.add_dependency 'httpclient', '~> 2.8', '>= 2.8.2.4'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'rspec',   '~> 3.0'
end
