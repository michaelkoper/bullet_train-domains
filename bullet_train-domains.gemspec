require_relative 'lib/bullet_train/domains/version'

Gem::Specification.new do |spec|
  spec.name        = 'bullet_train-domains'
  spec.version     = BulletTrain::Domains::VERSION
  spec.authors     = ['Michael Koper']
  spec.email       = ['hello@michaelkoper.com']
  spec.summary = 'Bullet Train Domains'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/michaelkoper/bullet_train-domains'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'bullet_train'
  spec.add_dependency 'rails', '>= 7.0'
  spec.add_development_dependency 'standard'
end
