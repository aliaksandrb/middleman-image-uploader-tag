# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require 'middleman/image-uploader-tag/version'

Gem::Specification.new do |s|
  s.name        = "middleman-image-uploader-tag"
  s.version     = Middleman::ImageUploaderTag::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aliaksandr Buhayeu"]
  s.email       = ["aliaksandr.buhayeu@gmail.com"]
  # s.homepage    = "http://example.com"
  s.summary     = %q{Image tag helper with automatic upload to external services}
  s.description = %q{
    The remote_image_tag helper provide you automatic image upload to external
    hosting services with public back-link mapping
  }
  s.license = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'middleman-core', ['>= 3.3.12']
  s.add_runtime_dependency 'cloudinary', '~>1.1.0'
end
