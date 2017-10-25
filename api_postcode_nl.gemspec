require File.join(File.dirname(__FILE__), 'lib/api_postcode_nl/version.rb')

Gem::Specification.new do |s|
  s.name = 'api_postcode_nl'
  s.version = ApiPostcodeNl::VERSION

  if s.respond_to? :required_rubygems_version=
    s.required_rubygems_version = Gem::Requirement.new('>= 0')
  end
  s.require_paths = ['lib']
  s.authors = ['rhomeister']
  s.date = '2016-11-18'
  s.description = 'Retrieve a Dutch address based on housenumber and postcode'
  s.email = 'r.stranders@gmail.com'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.rdoc'
  ]
  s.files = [
    '.document',
    'Gemfile',
    'LICENSE.txt',
    'README.rdoc',
    'Rakefile',
    'api_postcode_nl.gemspec',
    'lib/api_postcode_nl.rb',
    'lib/api_postcode_nl/api.rb',
    'lib/api_postcode_nl/exceptions.rb',
    'lib/api_postcode_nl/version.rb',
    'test/helper.rb',
    'test/test_api_postcode_nl.rb'
  ]
  s.homepage = 'http://github.com/rhomeister/api_postcode_nl'
  s.licenses = ['MIT']
  s.rubygems_version = '2.5.1'
  s.summary = 'Ruby gem for interfacing with api.postcode.nl'

  s.add_runtime_dependency('activesupport', ['>= 2.3.5'])
  s.add_development_dependency('minitest', ['~> 5.5'])
  s.add_development_dependency('rake', ['~> 12.0'])
  s.add_development_dependency('rdoc', ['~> 5.1.0'])
end
