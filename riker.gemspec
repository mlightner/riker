$:.unshift 'lib'

require 'riker/version'

Gem::Specification.new do |s|
  s.platform   = Gem::Platform::RUBY
  s.name       = 'riker'
  s.version    = Riker::Version
  s.date       = Time.now.strftime('%Y-%m-%d')
  s.summary    = 'Riker commands your Ruby CLIs, awesomely.'
  s.homepage   = 'https://github.com/site5/riker'
  s.authors    = ['Joshua Priddle']
  s.email      = 'jpriddle@site5.com'

  s.files      = %w[ Rakefile README.markdown ]
  s.files     += Dir['lib/**/*']
  s.files     += Dir['spec/**/*']

  # s.add_dependency('gem', '= 0.0.0')

  s.add_development_dependency('rspec', '~> 2.6')

  s.extra_rdoc_files = ['README.markdown']
  s.rdoc_options     = ["--charset=UTF-8"]

  s.description = "Riker commands your ruby CLIs, awesomely."
end
